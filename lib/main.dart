import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'providers/auth_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/pet_provider.dart';
import 'providers/subscription_provider.dart';
import 'screens/auth/auth_wrapper.dart';
import 'widgets/settings/language_dialog.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final prefs = await SharedPreferences.getInstance();
  // TODO(app-check): App Check activation temporarily disabled — attestation
  // was failing during development. Before production release, restore the
  // imports (firebase_app_check, flutter/foundation) and this block:
  //
  // await FirebaseAppCheck.instance.activate(
  //   providerAndroid: kDebugMode
  //       ? const AndroidDebugProvider()
  //       : const AndroidPlayIntegrityProvider(),
  //   providerApple: kDebugMode
  //       ? const AppleDebugProvider()
  //       : const AppleDeviceCheckProvider(),
  // );
  runApp(PawHealthApp(prefs: prefs));
  // Deferred until after the first frame: init parses the timezone database
  // on the main thread and may show the OS notification-permission prompt —
  // neither should block app startup. scheduleVaccineReminder() also calls
  // init() itself, so scheduling stays safe regardless of timing.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    NotificationService().init();
  });
}

class PawHealthApp extends StatelessWidget {
  final SharedPreferences prefs;

  const PawHealthApp({super.key, required this.prefs});

  /// Locale-appropriate playful fonts: Fredoka has no Thai or CJK glyphs,
  /// so Thai gets Mali and Simplified Chinese gets Noto Sans SC (full
  /// simplified-Chinese coverage — decorative CJK fonts like ZCOOL KuaiLe
  /// only ship a subset of characters and would leave tofu boxes).
  static ThemeData _themeForLocale(Locale locale) {
    final baseTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
    );

    final TextTheme fontTheme;
    final TextStyle appBarFont;
    switch (locale.languageCode) {
      case 'th':
        fontTheme = GoogleFonts.maliTextTheme(baseTheme.textTheme);
        appBarFont = GoogleFonts.mali();
      case 'zh':
        fontTheme = GoogleFonts.notoSansScTextTheme(baseTheme.textTheme);
        appBarFont = GoogleFonts.notoSansSc();
      default:
        fontTheme = GoogleFonts.fredokaTextTheme(baseTheme.textTheme);
        appBarFont = GoogleFonts.fredoka();
    }

    // Slightly heavier weights across the board: semi-bold headings/titles,
    // medium body — playful without sacrificing legibility.
    final textTheme = fontTheme.copyWith(
      headlineMedium: fontTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: fontTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      titleLarge: fontTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      titleMedium: fontTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      bodyLarge: fontTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      bodyMedium: fontTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
    );

    return baseTheme.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        titleTextStyle: appBarFont.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: baseTheme.colorScheme.onSurface,
        ),
        // Draw the status bar transparently over the app's own surface
        // color (no OS-default black/white strip), with dark icons for
        // contrast on the light theme.
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider(prefs)),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PetProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
      ],
      child: Builder(
        builder: (context) => MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          // Manual override: the user's stored choice wins over the system
          // locale (defaults to English until they pick one).
          locale: context.watch<LocaleProvider>().locale,
          theme: _themeForLocale(const Locale('en')),
          // The active locale is resolved by MaterialApp above this builder,
          // so the font-matched theme can be swapped in per locale here and
          // every route below the Navigator inherits it.
          builder: (context, child) {
            final theme = _themeForLocale(Localizations.localeOf(context));
            return Theme(data: theme, child: child!);
          },
          home: const _FirstLaunchLanguageGate(child: AuthWrapper()),
        ),
      ),
    );
  }
}

/// Shows the language-selection modal once, on the very first launch,
/// before any explicit choice has been stored.
class _FirstLaunchLanguageGate extends StatefulWidget {
  final Widget child;

  const _FirstLaunchLanguageGate({required this.child});

  @override
  State<_FirstLaunchLanguageGate> createState() =>
      _FirstLaunchLanguageGateState();
}

class _FirstLaunchLanguageGateState extends State<_FirstLaunchLanguageGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!context.read<LocaleProvider>().hasChosen) {
        LanguageDialog.show(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
