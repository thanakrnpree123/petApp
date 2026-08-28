import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../services/revenuecat_service.dart';

class SubscriptionProvider extends ChangeNotifier {
  final RevenueCatService _service;
  final FirebaseFirestore _firestore;

  bool isPlusMember = false;
  bool isLoading = false;
  String? errorCode;
  Offerings? offerings;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _premiumSub;

  SubscriptionProvider({RevenueCatService? service, FirebaseFirestore? firestore})
    : _service = service ?? RevenueCatService(),
      _firestore = firestore ?? FirebaseFirestore.instance {
    _service.addCustomerInfoListener(_onCustomerInfoUpdate);
  }

  Future<void> init(String userId) async {
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

    if (RevenueCatService.hasPlaceholderKeys) {
      debugPrint(
        'RevenueCat: skipping init — placeholder API keys in '
        'revenuecat_service.dart. Purchases stay disabled until real keys '
        'are added.',
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      await _service.init(appUserId: userId);
      offerings = await _service.fetchOfferings();
    } catch (e) {
      errorCode = 'load-failed';
    }

    isLoading = false;
    notifyListeners();
  }

  void _onCustomerInfoUpdate(CustomerInfo info) {
    // Web never configures RevenueCat, so this listener simply never fires
    // there — isPlusMember stays driven by the Firestore stream above.
    isPlusMember = info.entitlements.active.containsKey(
      RevenueCatService.entitlementId,
    );
    notifyListeners();
  }

  Future<bool> purchase(Package package) async {
    isLoading = true;
    errorCode = null;
    notifyListeners();

    try {
      await _service.purchasePackage(package);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorCode = 'purchase-failed';
      notifyListeners();
      return false;
    }
  }

  Future<bool> restore() async {
    isLoading = true;
    errorCode = null;
    notifyListeners();

    try {
      await _service.restorePurchases();
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorCode = 'restore-failed';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _service.removeCustomerInfoListener(_onCustomerInfoUpdate);
    _premiumSub?.cancel();
    super.dispose();
  }
}
