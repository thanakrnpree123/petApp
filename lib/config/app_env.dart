/// Build-time configuration, compiled in from a local `.env` file:
///
///     flutter run --dart-define-from-file=.env
///
/// See `.env.example` for the keys. Nothing here is a secret: the values
/// end up inside the app binary, where anyone can extract them, so only
/// ever put client-safe values here (RevenueCat's *public* SDK keys, never
/// a secret `sk_` key). `.env` keeps them out of git and lets each
/// machine or CI job use its own.
abstract final class AppEnv {
  /// RevenueCat public SDK key for the App Store app (starts with `appl_`).
  static const revenueCatAppleApiKey = String.fromEnvironment(
    'REVENUECAT_APPLE_API_KEY',
  );

  /// RevenueCat public SDK key for the Play Store app (starts with `goog_`).
  static const revenueCatGoogleApiKey = String.fromEnvironment(
    'REVENUECAT_GOOGLE_API_KEY',
  );

  /// Debug builds only: show a sample offering whenever the real one can't
  /// load, so the paywall can be built before the stores are set up.
  /// Ignored in release builds.
  static const revenueCatMock = bool.fromEnvironment('REVENUECAT_MOCK');

  /// Debug builds only: a fixed App Check debug token registered in the
  /// Firebase console (App Check → Apps → Manage debug tokens). It lets
  /// debug builds pass App Check without registering a new random token
  /// after every install. Treat it as a secret: anyone holding it can get
  /// valid App Check tokens for the project. Never set it for a release
  /// build.
  static const appCheckDebugToken = String.fromEnvironment(
    'APP_CHECK_DEBUG_TOKEN',
  );

  /// reCAPTCHA Enterprise site key for App Check on the web (public). Without
  /// one, release web builds skip App Check.
  static const appCheckWebSiteKey = String.fromEnvironment(
    'APP_CHECK_WEB_SITE_KEY',
  );
}
