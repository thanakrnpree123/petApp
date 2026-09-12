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
  /// e.g. "Sep 11, 2026" · "11 ก.ย. 2569" · "2026年9月11日".
  ///
  /// Thai readers expect the Buddhist Era year (พ.ศ. = C.E. + 543), which
  /// Intl doesn't offer.
  static AppDateFormat medium(BuildContext context) =>
      mediumFor(Localizations.localeOf(context));

  /// [medium] where there's no BuildContext (e.g. the PDF report).
  static AppDateFormat mediumFor(Locale locale) {
    if (locale.languageCode == 'th') return const _ThaiMediumDate();
    return _IntlDate(DateFormat.yMMMd(locale.toString()));
  }
}

/// Formats a date for display; see [AppDates].
abstract interface class AppDateFormat {
  String format(DateTime date);
}

class _IntlDate implements AppDateFormat {
  final DateFormat _format;

  const _IntlDate(this._format);

  @override
  String format(DateTime date) => _format.format(date);
}

class _ThaiMediumDate implements AppDateFormat {
  static const buddhistEraOffset = 543;

  const _ThaiMediumDate();

  // The year is appended rather than formatted from a shifted DateTime: the
  // shifted year's calendar differs (29 Feb 2024 would become 1 Mar 2567).
  @override
  String format(DateTime date) =>
      '${DateFormat('d MMM', 'th').format(date)} '
      '${date.year + buddhistEraOffset}';
}
