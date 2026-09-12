/// Accounts that always have full (Plus) access. For them the app skips
/// RevenueCat and the Firestore premium check entirely.
///
/// Matching ignores case and surrounding spaces: Firebase Auth stores
/// addresses lowercased, so a case-sensitive match against
/// "Thanakarn.123@gmail.com" would never succeed.
///
/// This is a client-side convenience, not a security boundary: it only
/// changes what this app shows. Anything a server must trust (e.g. the
/// Firestore `isPremium` flag) is set with the Admin SDK instead.
abstract final class AdminAccess {
  static const _adminEmails = {'thanakarn.123@gmail.com'};

  static bool isAdminEmail(String? email) =>
      email != null && _adminEmails.contains(email.trim().toLowerCase());
}
