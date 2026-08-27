import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// Scheduled reminders are a mobile-only feature. The web implementation
  /// needs a service worker that isn't registered here, and browser
  /// notifications can't fire reliably once the tab is closed — so the whole
  /// service no-ops on web rather than throwing at startup.
  static bool get isSupported => !kIsWeb;

  Future<void> init() async {
    if (_initialized || !isSupported) return;

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    final darwinSettings = DarwinInitializationSettings();
    final settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _plugin.initialize(settings: settings);

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    _initialized = true;
  }

  Future<void> scheduleVaccineReminder({
    required int id,
    required String petName,
    required String vaccineName,
    required DateTime nextDueDate,
  }) async {
    if (!isSupported) return;
    await init();

    final reminderTime = nextDueDate.subtract(const Duration(days: 1));
    if (reminderTime.isBefore(DateTime.now())) return;

    // tz.local defaults to UTC when setLocalLocation() hasn't been called,
    // but TZDateTime.from preserves the real-world instant from reminderTime
    // regardless of which zone it's labeled with, so a one-off (non-recurring)
    // schedule still fires at the correct moment without detecting the device's
    // actual time zone name.
    final scheduledDate = tz.TZDateTime.from(reminderTime, tz.local);

    await _plugin.zonedSchedule(
      id: id,
      title: 'Vaccine reminder for $petName',
      body: '$vaccineName is due tomorrow.',
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'vaccine_reminders',
          'Vaccine Reminders',
          channelDescription: 'Reminders for upcoming pet vaccinations',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> cancelReminder(int id) async {
    if (!isSupported) return;
    await _plugin.cancel(id: id);
  }
}
