import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

import '../config/app_env.dart';

/// The App Check providers for one build.
typedef AppCheckProviders = ({
  AndroidAppCheckProvider android,
  AppleAppCheckProvider apple,

  /// Null on the web when there's nothing to attest with (a release build
  /// without a reCAPTCHA site key): App Check is then skipped there.
  WebProvider? web,
});

/// Firebase App Check: debug builds use the debug providers (register the
/// token they print, or set APP_CHECK_DEBUG_TOKEN), release builds attest
/// with Play Integrity, App Attest (DeviceCheck fallback) and reCAPTCHA
/// Enterprise.
///
/// Enforcement stays OFF in the Firebase console until the metrics show
/// real traffic passing (docs/app-check-setup.md). Until then an app that
/// fails attestation keeps working, so a misconfigured provider only shows
/// up in the console metrics, never as a broken app.
abstract final class AppCheckSetup {
  static Future<void> activate() async {
    final providers = providersFor(
      debug: kDebugMode,
      isWeb: kIsWeb,
      debugToken: AppEnv.appCheckDebugToken,
      webSiteKey: AppEnv.appCheckWebSiteKey,
    );
    if (kIsWeb && providers.web == null) {
      debugPrint('App Check: no web site key; skipped on the web.');
      return;
    }
    try {
      await FirebaseAppCheck.instance.activate(
        providerAndroid: providers.android,
        providerApple: providers.apple,
        providerWeb: providers.web,
      );
      await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);
    } catch (e) {
      // Never block startup on App Check: with enforcement off the backend
      // still accepts requests without a token.
      debugPrint('App Check activation failed: $e');
    }
  }

  @visibleForTesting
  static AppCheckProviders providersFor({
    required bool debug,
    required bool isWeb,
    String debugToken = '',
    String webSiteKey = '',
  }) {
    if (debug) {
      final token = debugToken.isEmpty ? null : debugToken;
      return (
        android: AndroidDebugProvider(debugToken: token),
        apple: AppleDebugProvider(debugToken: token),
        web: isWeb ? WebDebugProvider(debugToken: token) : null,
      );
    }
    return (
      android: const AndroidPlayIntegrityProvider(),
      apple: const AppleAppAttestWithDeviceCheckFallbackProvider(),
      web: webSiteKey.isEmpty ? null : ReCaptchaEnterpriseProvider(webSiteKey),
    );
  }
}
