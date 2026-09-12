import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../services/admin_access.dart';
import '../services/revenuecat_service.dart';

/// Whether the paywall can sell a subscription right now — and if not, why,
/// so it can say so instead of showing a disabled button.
enum PurchaseAvailability {
  /// A package is loaded and can be bought.
  available,

  /// Offerings are still loading.
  loading,

  /// Web: no App Store / Play Store in-app purchase exists.
  mobileOnly,

  /// Offerings failed to load (e.g. offline) — worth a retry.
  loadFailed,

  /// No product to sell: no RevenueCat key, or the stores / dashboard
  /// aren't set up (no current offering).
  unavailable,
}

class SubscriptionProvider extends ChangeNotifier {
  final RevenueCatService _service;
  final FirebaseFirestore _firestore;

  bool isPlusMember = false;

  /// Plus via [AdminAccess], not a subscription.
  bool isAdmin = false;

  bool isLoading = false;
  String? errorCode;
  Offerings? offerings;

  /// The offering is the debug-only sample, not a real product.
  bool isMockOffering = false;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _premiumSub;
  String? _userId;
  String? _email;

  /// The package the paywall sells, if one is loaded.
  Package? get currentPackage {
    final packages = offerings?.current?.availablePackages ?? const [];
    return packages.isEmpty ? null : packages.first;
  }

  PurchaseAvailability get availability => availabilityFor(
    isWeb: kIsWeb,
    canSell: _service.canSell,
    isLoading: isLoading,
    loadFailed: errorCode == 'load-failed',
    hasPackage: currentPackage != null,
  );

  @visibleForTesting
  static PurchaseAvailability availabilityFor({
    required bool isWeb,
    required bool canSell,
    required bool isLoading,
    required bool loadFailed,
    required bool hasPackage,
  }) {
    if (isWeb) return PurchaseAvailability.mobileOnly;
    if (!canSell) return PurchaseAvailability.unavailable;
    // A loaded package stays "available" during a purchase/restore — the
    // paywall disables its buttons while isLoading instead.
    if (hasPackage) return PurchaseAvailability.available;
    if (isLoading) return PurchaseAvailability.loading;
    if (loadFailed) return PurchaseAvailability.loadFailed;
    return PurchaseAvailability.unavailable;
  }

  /// Re-runs [init] for the current user, e.g. after offerings failed to
  /// load while offline.
  Future<void> retry() async {
    final userId = _userId;
    if (userId == null) return;
    errorCode = null;
    await init(userId, email: _email);
  }

  SubscriptionProvider({
    RevenueCatService? service,
    FirebaseFirestore? firestore,
  }) : _service = service ?? RevenueCatService(),
       _firestore = firestore ?? FirebaseFirestore.instance {
    _service.addCustomerInfoListener(_onCustomerInfoUpdate);
  }

  /// Loads Plus status and offerings for the signed-in user. Never
  /// throws: every failure ends in an [availability] the paywall explains.
  Future<void> init(String userId, {String? email}) async {
    _userId = userId;
    _email = email;

    // Admin accounts get Plus without RevenueCat or Firestore.
    if (AdminAccess.isAdminEmail(email)) {
      await _premiumSub?.cancel();
      _premiumSub = null;
      isAdmin = true;
      isPlusMember = true;
      isLoading = false;
      errorCode = null;
      notifyListeners();
      return;
    }
    isAdmin = false;

    // App Store / Play Store in-app purchase doesn't exist on the web, so
    // Plus access there is granted by flipping `isPremium` on the user's
    // own Firestore document instead (see users/{uid}.isPremium — set via
    // the Firebase Console or an Admin SDK script, never by the client).
    // A live stream (not a one-shot get()) means a grant takes effect
    // immediately, without the user needing to log out and back in.
    if (kIsWeb) {
      isLoading = true;
      notifyListeners();

      await _premiumSub?.cancel();
      _premiumSub = _firestore
          .collection('users')
          .doc(userId)
          .snapshots()
          .listen(
            (doc) {
              isPlusMember = doc.data()?['isPremium'] == true;
              isLoading = false;
              notifyListeners();
            },
            onError: (Object _) {
              errorCode = 'load-failed';
              isLoading = false;
              notifyListeners();
            },
          );
      return;
    }

    if (!_service.canSell) {
      debugPrint(
        'RevenueCat: no API key for this platform — purchases disabled. '
        'Add it to .env (see .env.example) and run with '
        '--dart-define-from-file=.env.',
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    // Both calls report failures instead of throwing; a missing store
    // setup just leaves nothing to sell (or the debug mock).
    await _service.init(appUserId: userId);
    switch (await _service.fetchOfferings()) {
      case OfferingsLoaded(:final offerings, :final isMock):
        this.offerings = offerings;
        isMockOffering = isMock;
      case OfferingsUnavailable(:final reason):
        offerings = null;
        isMockOffering = false;
        errorCode = reason == OfferingsFailure.notSetUp
            ? 'not-set-up'
            : 'load-failed';
    }

    isLoading = false;
    notifyListeners();
  }

  void _onCustomerInfoUpdate(CustomerInfo info) {
    if (isAdmin) return;
    // Web never configures RevenueCat, so this listener simply never fires
    // there — isPlusMember stays driven by the Firestore stream above.
    isPlusMember = info.entitlements.active.containsKey(
      RevenueCatService.entitlementId,
    );
    notifyListeners();
  }

  /// Returns whether Plus is now active. A cancelled purchase is not an
  /// error.
  Future<bool> purchase(Package package) async {
    isLoading = true;
    errorCode = null;
    notifyListeners();

    final outcome = await _service.purchase(package);
    if (outcome == PurchaseOutcome.purchased) isPlusMember = true;
    if (outcome == PurchaseOutcome.failed) errorCode = 'purchase-failed';
    isLoading = false;
    notifyListeners();
    return outcome == PurchaseOutcome.purchased;
  }

  Future<bool> restore() async {
    isLoading = true;
    errorCode = null;
    notifyListeners();

    final active = await _service.restorePurchases();
    if (active == null) {
      errorCode = 'restore-failed';
    } else if (active) {
      isPlusMember = true;
    }
    isLoading = false;
    notifyListeners();
    return active != null;
  }

  /// Drops all state tied to the current user (e.g. after their account
  /// is deleted) so nothing carries over to the next sign-in.
  Future<void> reset() async {
    await _premiumSub?.cancel();
    _premiumSub = null;
    await _service.logOut();
    _userId = null;
    _email = null;
    isPlusMember = false;
    isAdmin = false;
    isLoading = false;
    errorCode = null;
    offerings = null;
    isMockOffering = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _service.removeCustomerInfoListener(_onCustomerInfoUpdate);
    _premiumSub?.cancel();
    super.dispose();
  }
}
