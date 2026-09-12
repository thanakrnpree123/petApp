import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/services/app_check_setup.dart';

void main() {
  group('debug builds', () {
    test('use the debug providers, with the configured token', () {
      final p = AppCheckSetup.providersFor(
        debug: true,
        isWeb: false,
        debugToken: 'token-123',
      );
      expect(p.android, isA<AndroidDebugProvider>());
      expect((p.android as AndroidDebugProvider).debugToken, 'token-123');
      expect(p.apple, isA<AppleDebugProvider>());
      expect((p.apple as AppleDebugProvider).debugToken, 'token-123');
    });

    test('without a token, let the SDK print one to register', () {
      final p = AppCheckSetup.providersFor(debug: true, isWeb: false);
      expect((p.android as AndroidDebugProvider).debugToken, isNull);
    });

    test('use the web debug provider on the web', () {
      final p = AppCheckSetup.providersFor(debug: true, isWeb: true);
      expect(p.web, isA<WebDebugProvider>());
    });
  });

  group('release builds', () {
    test(
      'attest with Play Integrity and App Attest, never a debug provider',
      () {
        // Even if a debug token leaked into a release .env.
        final p = AppCheckSetup.providersFor(
          debug: false,
          isWeb: false,
          debugToken: 'token-123',
        );
        expect(p.android, isA<AndroidPlayIntegrityProvider>());
        expect(p.apple, isA<AppleAppAttestWithDeviceCheckFallbackProvider>());
      },
    );

    test('use reCAPTCHA Enterprise on the web once a site key is set', () {
      final p = AppCheckSetup.providersFor(
        debug: false,
        isWeb: true,
        webSiteKey: 'site-key',
      );
      expect(p.web, isA<ReCaptchaEnterpriseProvider>());
      expect(p.web!.siteKey, 'site-key');
    });

    test('skip the web without a site key', () {
      final p = AppCheckSetup.providersFor(debug: false, isWeb: true);
      expect(p.web, isNull);
    });
  });
}
