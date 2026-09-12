import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawhealth/theme/app_theme.dart';

/// Fonts must come from the app bundle: with runtime fetching off, a
/// missing file would make text fall back to the platform font silently.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const weights = [
    FontWeight.w400,
    FontWeight.w500,
    FontWeight.w600,
    FontWeight.w700,
    FontWeight.w800,
  ];

  test('every font and weight the theme uses is bundled', () async {
    AppTheme.useBundledFonts();
    expect(GoogleFonts.config.allowRuntimeFetching, isFalse);

    // google_fonts reports a missing font with debugPrint, not a throw.
    final logs = <String>[];
    final original = debugPrint;
    debugPrint = (message, {wrapWidth}) => logs.add(message ?? '');
    addTearDown(() => debugPrint = original);

    for (final locale in const [Locale('en'), Locale('th'), Locale('zh')]) {
      AppTheme.forLocale(locale);
      for (final weight in weights) {
        AppTheme.fontFor(locale, TextStyle(fontWeight: weight));
      }
    }
    await GoogleFonts.pendingFonts();

    expect(logs.where((l) => l.contains('unable to load font')), isEmpty);
  });

  test('Chinese uses the system font instead of a 10 MB-per-weight one', () {
    final theme = AppTheme.forLocale(const Locale('zh'));
    for (final family in [
      theme.textTheme.bodyLarge?.fontFamily,
      AppTheme.fontFor(const Locale('zh')).fontFamily,
    ]) {
      // The platform default (e.g. Roboto + CJK fallback), not a Google
      // font that would need bundling.
      expect(family ?? '', isNot(contains('_')));
    }
  });

  test("the fonts' Open Font License appears on the licenses page", () async {
    AppTheme.useBundledFonts();
    final packages = <String>{
      await for (final entry in LicenseRegistry.licenses) ...entry.packages,
    };
    expect(
      packages,
      containsAll(['Nunito', 'IBM Plex Sans Thai Looped', 'Noto Sans SC']),
    );
  });
}
