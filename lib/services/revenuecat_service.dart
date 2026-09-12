import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../config/app_env.dart';

/// Why offerings couldn't be loaded.
enum OfferingsFailure {
  /// Offline or timed out — worth a retry.
  network,

  /// Keys, stores or the RevenueCat dashboard aren't set up yet (no keys,
  /// no products, no current offering, invalid credentials).
  notSetUp,

  /// Anything else.
  unknown,
}

sealed class OfferingsResult {
  const OfferingsResult();
}

class OfferingsLoaded extends OfferingsResult {
  final Offerings offerings;

  /// The debug-only sample from [RevenueCatService.mockOfferings].
  final bool isMock;

  const OfferingsLoaded(this.offerings, {this.isMock = false});
}

class OfferingsUnavailable extends OfferingsResult {
  final OfferingsFailure reason;

  const OfferingsUnavailable(this.reason);
}

enum PurchaseOutcome { purchased, cancelled, failed }

/// RevenueCat, wrapped so the app never crashes or hangs on it: every call
/// catches its errors, times out, and reports a result instead of
/// throwing. Missing keys, unset-up stores and offline devices all end in
/// "nothing to sell right now", never an exception.
class RevenueCatService {
  static const String entitlementId = 'plus';

  static const _timeout = Duration(seconds: 15);
  static const _mockOfferingId = 'mock';

  final String _appleApiKey;
  final String _googleApiKey;
  final bool _mockRequested;
  final TargetPlatform _platform;

  /// The web has no app store; Plus comes from Firestore there.
  final bool isWeb;

  bool _configured = false;

  RevenueCatService({
    String appleApiKey = AppEnv.revenueCatAppleApiKey,
    String googleApiKey = AppEnv.revenueCatGoogleApiKey,
    bool useMockOfferings = AppEnv.revenueCatMock,
    TargetPlatform? platform,
    this.isWeb = kIsWeb,
  }) : _appleApiKey = appleApiKey.trim(),
       _googleApiKey = googleApiKey.trim(),
       _mockRequested = useMockOfferings,
       _platform = platform ?? defaultTargetPlatform;

  /// The public SDK key for this platform, or null when there's no usable
  /// one: no key, the web (which has no store; Plus comes from Firestore
  /// there), or a key that can't be right for this platform.
  String? get apiKey {
    if (isWeb) return null;
    final (key, prefix) = switch (_platform) {
      TargetPlatform.iOS || TargetPlatform.macOS => (_appleApiKey, 'appl_'),
      TargetPlatform.android => (_googleApiKey, 'goog_'),
      _ => ('', ''),
    };
    if (key.isEmpty) return null;
    if (key.startsWith('sk_')) {
      // A secret key in the app would let anyone who unpacks it grant
      // entitlements. Refuse it outright.
      debugPrint(
        'RevenueCat: a SECRET key (sk_…) was provided. Never ship it in '
        'the app — use the public SDK key. Purchases disabled.',
      );
      return null;
    }
    if (!key.startsWith(prefix)) {
      debugPrint(
        'RevenueCat: expected a key starting with "$prefix" for '
        '${_platform.name}. Purchases disabled.',
      );
      return null;
    }
    return key;
  }

  bool get hasApiKey => apiKey != null;

  /// Debug builds only, and only when asked for in `.env`.
  bool get useMockOfferings => kDebugMode && _mockRequested && !isWeb;

  /// Whether the paywall can have something to show at all.
  bool get canSell => hasApiKey || useMockOfferings;

  /// Configures the SDK for [appUserId], or switches to that user if it is
  /// already configured. Returns whether RevenueCat is ready.
  Future<bool> init({required String appUserId}) async {
    final key = apiKey;
    if (key == null) return false;
    try {
      if (_configured) {
        await Purchases.logIn(appUserId).timeout(_timeout);
      } else {
        await Purchases.setLogLevel(
          kDebugMode ? LogLevel.debug : LogLevel.warn,
        );
        await Purchases.configure(
          PurchasesConfiguration(key)..appUserID = appUserId,
        ).timeout(_timeout);
        _configured = true;
      }
      return true;
    } catch (e) {
      debugPrint('RevenueCat: init failed: $e');
      return false;
    }
  }

  /// The current offerings; in debug builds with mock offerings enabled, a
  /// sample whenever the real ones can't be loaded or are empty.
  Future<OfferingsResult> fetchOfferings() async {
    final OfferingsResult result;
    if (!_configured) {
      result = const OfferingsUnavailable(OfferingsFailure.notSetUp);
    } else {
      result = await _fetchReal();
    }
    if (result is OfferingsUnavailable && useMockOfferings) {
      debugPrint(
        'RevenueCat: using MOCK offerings (${result.reason.name}). '
        'Debug builds only.',
      );
      return OfferingsLoaded(mockOfferings(), isMock: true);
    }
    return result;
  }

  Future<OfferingsResult> _fetchReal() async {
    try {
      final offerings = await Purchases.getOfferings().timeout(_timeout);
      if (offerings.current?.availablePackages.isEmpty ?? true) {
        // Configured, but no current offering with packages on the
        // dashboard yet.
        return const OfferingsUnavailable(OfferingsFailure.notSetUp);
      }
      return OfferingsLoaded(offerings);
    } on TimeoutException {
      return const OfferingsUnavailable(OfferingsFailure.network);
    } on PlatformException catch (e) {
      debugPrint('RevenueCat: getOfferings failed: ${e.code} ${e.message}');
      return OfferingsUnavailable(failureFor(e));
    } catch (e) {
      debugPrint('RevenueCat: getOfferings failed: $e');
      return const OfferingsUnavailable(OfferingsFailure.unknown);
    }
  }

  @visibleForTesting
  static OfferingsFailure failureFor(PlatformException e) =>
      switch (PurchasesErrorHelper.getErrorCode(e)) {
        PurchasesErrorCode.networkError ||
        PurchasesErrorCode.offlineConnectionError ||
        PurchasesErrorCode.productRequestTimeout => OfferingsFailure.network,
        PurchasesErrorCode.configurationError ||
        PurchasesErrorCode.invalidCredentialsError ||
        PurchasesErrorCode.productNotAvailableForPurchaseError ||
        PurchasesErrorCode.storeProblemError ||
        PurchasesErrorCode.invalidAppleSubscriptionKeyError =>
          OfferingsFailure.notSetUp,
        _ => OfferingsFailure.unknown,
      };

  /// Buys [package]. A mock package "succeeds" without any store, so the
  /// paywall → Plus flow can be tried in debug builds.
  Future<PurchaseOutcome> purchase(Package package) async {
    if (isMockPackage(package)) {
      return useMockOfferings
          ? PurchaseOutcome.purchased
          : PurchaseOutcome.failed;
    }
    try {
      final result = await Purchases.purchase(PurchaseParams.package(package));
      return result.customerInfo.entitlements.active.containsKey(entitlementId)
          ? PurchaseOutcome.purchased
          : PurchaseOutcome.failed;
    } on PlatformException catch (e) {
      return PurchasesErrorHelper.getErrorCode(e) ==
              PurchasesErrorCode.purchaseCancelledError
          ? PurchaseOutcome.cancelled
          : PurchaseOutcome.failed;
    } catch (e) {
      debugPrint('RevenueCat: purchase failed: $e');
      return PurchaseOutcome.failed;
    }
  }

  /// Restores past purchases. Returns whether Plus is active afterwards,
  /// or null if the restore itself failed.
  Future<bool?> restorePurchases() async {
    if (!_configured) return null;
    try {
      final info = await Purchases.restorePurchases().timeout(_timeout);
      return info.entitlements.active.containsKey(entitlementId);
    } catch (e) {
      debugPrint('RevenueCat: restore failed: $e');
      return null;
    }
  }

  /// Detaches the signed-in user, so the next one starts clean.
  Future<void> logOut() async {
    if (!_configured) return;
    try {
      await Purchases.logOut().timeout(_timeout);
    } catch (_) {
      // Already anonymous, or offline: nothing to undo.
    }
  }

  void addCustomerInfoListener(CustomerInfoUpdateListener listener) =>
      Purchases.addCustomerInfoUpdateListener(listener);

  void removeCustomerInfoListener(CustomerInfoUpdateListener listener) =>
      Purchases.removeCustomerInfoUpdateListener(listener);

  static bool isMockPackage(Package package) =>
      package.presentedOfferingContext.offeringIdentifier == _mockOfferingId;

  /// A sample monthly Plus offering, clearly labelled as a mock.
  @visibleForTesting
  static Offerings mockOfferings() {
    const context = PresentedOfferingContext(_mockOfferingId, null, null);
    const product = StoreProduct(
      'pawhealth_plus_monthly',
      'Sample product for development. No real purchase.',
      'PawHealth Plus (mock)',
      2.99,
      r'$2.99 (mock)',
      'USD',
    );
    const package = Package(
      r'$rc_monthly',
      PackageType.monthly,
      product,
      context,
    );
    const offering = Offering(
      _mockOfferingId,
      'Mock offering (debug builds only)',
      {},
      [package],
      monthly: package,
    );
    return const Offerings({_mockOfferingId: offering}, current: offering);
  }
}
