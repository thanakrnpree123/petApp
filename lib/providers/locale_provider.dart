import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const _localeKey = 'locale_code';
  static const supported = [Locale('en'), Locale('th'), Locale('zh')];

  final SharedPreferences _prefs;

  Locale _locale;
  bool _hasChosen;

  LocaleProvider(this._prefs)
    : _locale = Locale(_prefs.getString(_localeKey) ?? 'en'),
      _hasChosen = _prefs.containsKey(_localeKey);

  /// Active app locale. Defaults to English until the user picks one.
  Locale get locale => _locale;

  /// Whether the user has ever made an explicit choice (drives the
  /// first-launch language modal).
  bool get hasChosen => _hasChosen;

  /// The language's own name for itself — always shown untranslated so a
  /// user stuck in the wrong language can still find theirs.
  static String endonym(Locale locale) => switch (locale.languageCode) {
    'th' => 'ไทย',
    'zh' => '简体中文',
    _ => 'English',
  };

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    _hasChosen = true;
    notifyListeners();
    await _prefs.setString(_localeKey, locale.languageCode);
  }
}
