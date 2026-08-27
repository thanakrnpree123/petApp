import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../services/revenuecat_service.dart';

class SubscriptionProvider extends ChangeNotifier {
  final RevenueCatService _service;

  bool isPlusMember = false;
  bool isLoading = false;
  String? errorCode;
  Offerings? offerings;

  SubscriptionProvider({RevenueCatService? service})
    : _service = service ?? RevenueCatService() {
    _service.addCustomerInfoListener(_onCustomerInfoUpdate);
  }

  Future<void> init(String userId) async {
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
    super.dispose();
  }
}
