/// Where the Terms of Use and Privacy Policy live. Both app stores require
/// working links to them on the paywall, and Google Play also requires the
/// privacy policy inside the app (it's in Settings).
///
/// PLACEHOLDERS: these paths on the app's own web host don't exist yet.
/// Publish the documents at exactly these URLs (e.g. web/legal/*.html) and
/// the links start working in already-shipped builds, with no app update.
abstract final class LegalLinks {
  static final termsOfUse = Uri.parse(
    'https://thanakrnpree123.github.io/petApp/legal/terms.html',
  );

  static final privacyPolicy = Uri.parse(
    'https://thanakrnpree123.github.io/petApp/legal/privacy.html',
  );
}
