import '../l10n/app_localizations.dart';

class Validators {
  static String? email(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.emailRequired;
    }
    final regex = RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value.trim())) {
      return l10n.emailInvalid;
    }
    return null;
  }

  static String? password(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.passwordRequired;
    }
    if (value.length < 6) {
      return l10n.passwordTooShort;
    }
    return null;
  }

  static String? confirmPassword(
    String? value,
    String originalPassword,
    AppLocalizations l10n,
  ) {
    if (value != originalPassword) {
      return l10n.passwordsDoNotMatch;
    }
    return null;
  }

  /// Plausible pet weights. The ceiling catches unit slips (grams typed as
  /// kilograms) that would otherwise flatten the weight chart; the largest
  /// giant breeds stay well under it.
  static const minWeightKg = 0.1;
  static const maxWeightKg = 150.0;

  /// Parses a weight, accepting a decimal comma ("4,5") as well as a dot —
  /// many keyboards offer only the comma.
  static double? parseWeight(String? value) =>
      double.tryParse((value ?? '').trim().replaceAll(',', '.'));

  static String? weightKg(String? value, AppLocalizations l10n) {
    final parsed = parseWeight(value);
    if (parsed == null) return l10n.enterValidWeight;
    if (parsed < minWeightKg || parsed > maxWeightKg) {
      return l10n.weightOutOfRange;
    }
    return null;
  }
}
