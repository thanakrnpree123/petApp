import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'providers/auth_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/pet_provider.dart';
import 'providers/subscription_provider.dart';
import 'screens/auth/auth_wrapper.dart';
import 'theme/app_theme.dart';
import 'widgets/settings/language_dialog.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppTheme.useBundledFonts();
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
  // on the main thread, which shouldn't block app startup. It never asks
  // for notification permission — that happens in context, when the user
  // first adds a vaccine (see ReminderPermissionPrompt).
  WidgetsBinding.instance.addPostFrameCallback((_) {
    NotificationService().init();
  });
}

class PawHealthApp extends StatelessWidget {
  final SharedPreferences prefs;

  const PawHealthApp({super.key, required this.prefs});

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
          theme: AppTheme.forLocale(const Locale('en')),
          // The active locale is resolved by MaterialApp above this builder,
          // so the font-matched theme can be swapped in per locale here and
          // every route below the Navigator inherits it.
          builder: (context, child) {
            final theme = AppTheme.forLocale(Localizations.localeOf(context));
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
