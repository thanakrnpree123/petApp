import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/services/revenuecat_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

RevenueCatService _service({
  String apple = '',
  String google = '',
  bool mock = false,
  TargetPlatform platform = TargetPlatform.iOS,
  bool isWeb = false,
}) => RevenueCatService(
  appleApiKey: apple,
  googleApiKey: google,
  useMockOfferings: mock,
  platform: platform,
  isWeb: isWeb,
);

PlatformException _error(PurchasesErrorCode code) =>
    PlatformException(code: '${code.index}');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('API keys', () {
    test('uses the public key for the platform', () {
      expect(_service(apple: 'appl_abc').apiKey, 'appl_abc');
      expect(
        _service(google: 'goog_abc', platform: TargetPlatform.android).apiKey,
        'goog_abc',
      );
    });

    test('no key, or the web, means nothing to configure', () {
      expect(_service().apiKey, isNull);
      expect(_service(apple: 'appl_abc', isWeb: true).apiKey, isNull);
    });

    test('refuses a secret key and a key for the other store', () {
      expect(_service(apple: 'sk_live_secret').apiKey, isNull);
      expect(_service(apple: 'goog_abc').apiKey, isNull);
      expect(
        _service(google: 'appl_abc', platform: TargetPlatform.android).apiKey,
        isNull,
      );
    });
  });

  group('never crashes before the stores are set up', () {
    test('init reports failure when the SDK is unreachable', () async {
      // No native plugin in tests: every SDK call throws underneath.
      expect(await _service(apple: 'appl_abc').init(appUserId: 'u1'), isFalse);
    });

    test('no keys and no mock: offerings are "not set up"', () async {
      final result = await _service().fetchOfferings();
      expect(result, isA<OfferingsUnavailable>());
      expect(
        (result as OfferingsUnavailable).reason,
        OfferingsFailure.notSetUp,
      );
    });

    test('with the mock enabled, a sample offering stands in', () async {
      final result = await _service(mock: true).fetchOfferings();
      expect(result, isA<OfferingsLoaded>());
      final loaded = result as OfferingsLoaded;
      expect(loaded.isMock, isTrue);
      final package = loaded.offerings.current!.availablePackages.single;
      expect(package.storeProduct.priceString, contains('mock'));
      expect(RevenueCatService.isMockPackage(package), isTrue);
    });

    test('a failed init still falls back to the mock', () async {
      final service = _service(apple: 'appl_abc', mock: true);
      await service.init(appUserId: 'u1');
      expect(await service.fetchOfferings(), isA<OfferingsLoaded>());
    });

    test('restore and log out are safe without a configured SDK', () async {
      final service = _service();
      expect(await service.restorePurchases(), isNull);
      await service.logOut();
    });
  });

  test('store errors map to a retry, "not set up", or unknown', () {
    expect(
      RevenueCatService.failureFor(_error(PurchasesErrorCode.networkError)),
      OfferingsFailure.network,
    );
    expect(
      RevenueCatService.failureFor(
        _error(PurchasesErrorCode.offlineConnectionError),
      ),
      OfferingsFailure.network,
    );
    expect(
      RevenueCatService.failureFor(
        _error(PurchasesErrorCode.configurationError),
      ),
      OfferingsFailure.notSetUp,
    );
    expect(
      RevenueCatService.failureFor(
        _error(PurchasesErrorCode.invalidCredentialsError),
      ),
      OfferingsFailure.notSetUp,
    );
    expect(
      RevenueCatService.failureFor(_error(PurchasesErrorCode.unknownError)),
      OfferingsFailure.unknown,
    );
  });

  group('mock purchases', () {
    final mockPackage =
        RevenueCatService.mockOfferings().current!.availablePackages.single;

    test('succeed while the mock is enabled', () async {
      expect(
        await _service(mock: true).purchase(mockPackage),
        PurchaseOutcome.purchased,
      );
    });

    test('never grant anything once the mock is off', () async {
      expect(await _service().purchase(mockPackage), PurchaseOutcome.failed);
    });
  });

  test('the mock is never used on the web', () {
    expect(_service(mock: true, isWeb: true).useMockOfferings, isFalse);
  });
}
