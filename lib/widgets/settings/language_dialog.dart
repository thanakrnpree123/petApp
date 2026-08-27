import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/locale_provider.dart';

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({super.key});

  /// Each language name must be drawn in a font that covers its own script.
  /// The active theme font follows the *current* locale (e.g. Fredoka for
  /// English), which has no Thai or CJK glyphs — leaving the other options
  /// rendered as tofu boxes for the very users who need to find them.
  static TextStyle _styleFor(Locale locale) => switch (locale.languageCode) {
    'th' => GoogleFonts.mali(),
    'zh' => GoogleFonts.notoSansSc(),
    _ => GoogleFonts.fredoka(),
  };

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const LanguageDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.language),
          const SizedBox(width: 8),
          Expanded(child: Text(AppLocalizations.of(context)!.chooseLanguage)),
        ],
      ),
      content: RadioGroup<String>(
        groupValue: localeProvider.locale.languageCode,
        onChanged: (code) {
          if (code == null) return;
          context.read<LocaleProvider>().setLocale(Locale(code));
          Navigator.of(context).pop();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final locale in LocaleProvider.supported)
              RadioListTile<String>(
                value: locale.languageCode,
                title: Text(
                  LocaleProvider.endonym(locale),
                  style: _styleFor(locale),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
