/// Where the Terms of Use and Privacy Policy live. Both app stores require
/// working links to them on the paywall, and Google Play also requires the
/// privacy policy inside the app (it's in Settings).
///
/// The pages are web/legal/*.html, deployed with the web app. Shipped app
/// builds link to these exact URLs, so never move or rename the files.
abstract final class LegalLinks {
  static final termsOfUse = Uri.parse(
    'https://thanakrnpree123.github.io/petApp/legal/terms.html',
  );

  static final privacyPolicy = Uri.parse(
    'https://thanakrnpree123.github.io/petApp/legal/privacy.html',
  );

  /// Not linked in the app (deletion is in Settings), but Google Play's
  /// Data safety form requires this web page.
  static final accountDeletion = Uri.parse(
    'https://thanakrnpree123.github.io/petApp/legal/delete-account.html',
  );
}
