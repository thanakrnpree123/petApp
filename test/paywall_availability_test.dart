import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/l10n/app_localizations.dart';
import 'package:pawhealth/providers/subscription_provider.dart';
import 'package:pawhealth/screens/subscription/paywall_screen.dart';
import 'package:pawhealth/services/revenuecat_service.dart';
import 'package:pawhealth/theme/app_theme.dart';
import 'package:provider/provider.dart';

class _FakeFirestore implements FirebaseFirestore {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

PurchaseAvailability _availability({
  bool isWeb = false,
  bool canSell = true,
  bool isLoading = false,
  bool loadFailed = false,
  bool hasPackage = false,
}) => SubscriptionProvider.availabilityFor(
  isWeb: isWeb,
  canSell: canSell,
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

    test('no RevenueCat key (and no mock) means nothing to sell', () {
      expect(_availability(canSell: false), PurchaseAvailability.unavailable);
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
    final subscription = SubscriptionProvider(
      // No keys and no mock: the state before RevenueCat is set up.
      service: RevenueCatService(
        appleApiKey: '',
        googleApiKey: '',
        useMockOfferings: false,
      ),
      firestore: _FakeFirestore(),
    );
    await _pumpPaywall(tester, subscription);
    await subscription.init('u1', email: 'someone@example.com');
    await tester.pump();

    expect(
      find.text(
        "Subscriptions aren't available right now. Please try again later.",
      ),
      findsOneWidget,
    );
    expect(find.text('Subscribe'), findsNothing);
    expect(find.textContaining(r'$2.99'), findsNothing);
    // The app shows no ads, so neither tier may mention them.
    expect(
      find.textContaining(RegExp(r'\bads?\b', caseSensitive: false)),
      findsNothing,
    );
  });

  testWidgets('the debug mock offering can be bought end to end', (
    tester,
  ) async {
    final subscription = SubscriptionProvider(
      service: RevenueCatService(
        appleApiKey: '',
        googleApiKey: '',
        useMockOfferings: true,
      ),
      firestore: _FakeFirestore(),
    );
    await _pumpPaywall(tester, subscription);
    await subscription.init('u1', email: 'someone@example.com');
    await tester.pumpAndSettle();

    expect(subscription.isMockOffering, isTrue);
    expect(find.textContaining(r'$2.99 (mock)'), findsOneWidget);

    await tester.tap(find.text('Subscribe'));
    await tester.pumpAndSettle();

    expect(subscription.isPlusMember, isTrue);
    expect(
      find.byType(PaywallScreen),
      findsNothing,
      reason: 'closes on success',
    );
  });
}

/// The paywall pushed over a home screen, as in the app.
Future<void> _pumpPaywall(
  WidgetTester tester,
  SubscriptionProvider subscription,
) async {
  await tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: subscription,
      child: MaterialApp(
        theme: ThemeData(extensions: const [StatusColors.light]),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const PaywallScreen()),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}
