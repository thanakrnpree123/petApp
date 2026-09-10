import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/l10n/app_localizations.dart';
import 'package:pawhealth/providers/subscription_provider.dart';
import 'package:pawhealth/screens/subscription/paywall_screen.dart';
import 'package:pawhealth/services/revenuecat_service.dart';
import 'package:pawhealth/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class _FakeRevenueCat implements RevenueCatService {
  @override
  void addCustomerInfoListener(CustomerInfoUpdateListener listener) {}

  @override
  void removeCustomerInfoListener(CustomerInfoUpdateListener listener) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeFirestore implements FirebaseFirestore {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

PurchaseAvailability _availability({
  bool isWeb = false,
  bool hasPlaceholderKeys = false,
  bool isLoading = false,
  bool loadFailed = false,
  bool hasPackage = false,
}) => SubscriptionProvider.availabilityFor(
  isWeb: isWeb,
  hasPlaceholderKeys: hasPlaceholderKeys,
  isLoading: isLoading,
  loadFailed: loadFailed,
  hasPackage: hasPackage,
);

void main() {
  group('availabilityFor', () {
    test('web explains the app stores, whatever else is true', () {
      expect(
        _availability(isWeb: true, hasPackage: true),
        PurchaseAvailability.mobileOnly,
      );
    });

    test('placeholder RevenueCat keys mean nothing to sell', () {
      expect(
        _availability(hasPlaceholderKeys: true),
        PurchaseAvailability.unavailable,
      );
    });

    test('a loaded package can be bought, even mid-purchase', () {
      expect(_availability(hasPackage: true), PurchaseAvailability.available);
      expect(
        _availability(hasPackage: true, isLoading: true),
        PurchaseAvailability.available,
      );
    });

    test('loading, failed and empty offerings are distinguished', () {
      expect(_availability(isLoading: true), PurchaseAvailability.loading);
      expect(_availability(loadFailed: true), PurchaseAvailability.loadFailed);
      expect(_availability(), PurchaseAvailability.unavailable);
    });
  });

  testWidgets('with nothing to sell, the paywall explains instead of '
      'showing a dead Subscribe button', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => SubscriptionProvider(
          service: _FakeRevenueCat(),
          firestore: _FakeFirestore(),
        ),
        child: MaterialApp(
          theme: ThemeData(extensions: const [StatusColors.light]),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const PaywallScreen(),
        ),
      ),
    );

    // This repo still has placeholder RevenueCat keys, so no product loads.
    expect(RevenueCatService.hasPlaceholderKeys, isTrue);
    expect(
      find.text(
        "Subscriptions aren't available right now. Please try again later.",
      ),
      findsOneWidget,
    );
    expect(find.text('Subscribe'), findsNothing);
    expect(find.textContaining(r'$2.99'), findsNothing);
  });
}
