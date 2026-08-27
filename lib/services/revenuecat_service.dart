import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  // TODO: replace with your real keys from the RevenueCat dashboard
  // (Project Settings > API Keys) before release.
  static const String _androidApiKey = 'YOUR_REVENUECAT_ANDROID_API_KEY';
  static const String _iosApiKey = 'YOUR_REVENUECAT_IOS_API_KEY';

  static const String entitlementId = 'plus';

  /// True until the placeholder keys above are replaced with real ones.
  /// While true, the SDK is never configured and all purchase features
  /// stay dormant instead of erroring on every launch.
  static bool get hasPlaceholderKeys =>
      _androidApiKey.startsWith('YOUR_') || _iosApiKey.startsWith('YOUR_');

  Future<void> init({required String appUserId}) async {
    await Purchases.setLogLevel(LogLevel.warn);

    // defaultTargetPlatform instead of dart:io Platform so this compiles
    // on web too.
    final configuration = PurchasesConfiguration(
      defaultTargetPlatform == TargetPlatform.iOS ? _iosApiKey : _androidApiKey,
    )..appUserID = appUserId;

    await Purchases.configure(configuration);
  }

  void addCustomerInfoListener(CustomerInfoUpdateListener listener) {
    Purchases.addCustomerInfoUpdateListener(listener);
  }

  void removeCustomerInfoListener(CustomerInfoUpdateListener listener) {
    Purchases.removeCustomerInfoUpdateListener(listener);
  }

  Future<CustomerInfo> getCustomerInfo() => Purchases.getCustomerInfo();

  Future<Offerings> fetchOfferings() => Purchases.getOfferings();

  Future<CustomerInfo> purchasePackage(Package package) async {
    final result = await Purchases.purchase(PurchaseParams.package(package));
    return result.customerInfo;
  }

  Future<CustomerInfo> restorePurchases() => Purchases.restorePurchases();
}
