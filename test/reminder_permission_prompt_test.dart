import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/l10n/app_localizations.dart';
import 'package:pawhealth/services/notification_service.dart';
import 'package:pawhealth/widgets/health/reminder_permission_prompt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeNotificationService implements NotificationService {
  _FakeNotificationService({this.enabled = false});
  final bool enabled;
  int requests = 0;

  @override
  Future<bool> areNotificationsEnabled() async => enabled;

  @override
  Future<bool> requestPermission() async {
    requests++;
    return true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> _ask(WidgetTester tester, NotificationService service) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => ReminderPermissionPrompt.maybeAsk(
              context,
              petName: 'Mochi',
              notificationService: service,
            ),
            child: const Text('add vaccine'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('add vaccine'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('explains first, then shows the OS prompt on Turn On', (
    tester,
  ) async {
    final service = _FakeNotificationService();
    await _ask(tester, service);

    expect(find.text('Get vaccine reminders?'), findsOneWidget);
    expect(find.textContaining('Mochi'), findsOneWidget);
    expect(service.requests, 0, reason: 'OS prompt must wait for consent');

    await tester.tap(find.text('Turn On'));
    await tester.pumpAndSettle();

    expect(service.requests, 1);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(ReminderPermissionPrompt.askedKey), isTrue);
  });

  testWidgets('"Not now" skips the OS prompt and never asks again', (
    tester,
  ) async {
    final service = _FakeNotificationService();
    await _ask(tester, service);
    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();
    expect(service.requests, 0);

    await tester.tap(find.text('add vaccine'));
    await tester.pumpAndSettle();
    expect(find.text('Get vaccine reminders?'), findsNothing);
  });

  testWidgets('stays silent when reminders are already allowed', (
    tester,
  ) async {
    final service = _FakeNotificationService(enabled: true);
    await _ask(tester, service);

    expect(find.byType(AlertDialog), findsNothing);
    expect(service.requests, 0);
  });
}
