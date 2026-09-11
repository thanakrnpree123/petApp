import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Date formats in the app's current language.
///
/// A bare `DateFormat.yMMMd()` uses Intl's default locale, which the app
/// never sets — so Thai and Chinese screens showed "Sep 11, 2026" inside
/// otherwise-translated text. Always format on-screen dates through here.
/// (Date symbols for every supported locale are loaded by the
/// GlobalMaterialLocalizations delegate.)
abstract final class AppDates {
  /// e.g. "Sep 11, 2026" · "11 ก.ย. 2026" · "2026年9月11日".
  static DateFormat medium(BuildContext context) =>
      DateFormat.yMMMd(Localizations.localeOf(context).toString());
}
