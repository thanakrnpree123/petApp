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

  /// The notification id for a vaccination's reminder, derived from its
  /// Firestore id. Must be stable across launches and SDK upgrades so a
  /// reminder scheduled today can still be cancelled later — which
  /// String.hashCode doesn't promise. A 31-bit polynomial hash fits the
  /// 32-bit ids Android requires and stays exact under web int math.
  static int vaccineReminderId(String vaccinationId) {
    const modulus = 2147483647; // 2^31 - 1
    var hash = 0;
    for (final unit in vaccinationId.codeUnits) {
      hash = (hash * 31 + unit) % modulus;
    }
    return hash;
  }

  /// Sets up the plugin WITHOUT asking for permission. Permission is
  /// requested in context — when the user first adds a vaccine — by
  /// [requestPermission]; asking at launch, before the user knows what
  /// reminders are for, gets denied, and iOS never asks twice.
  Future<void> init() async {
    if (_initialized || !isSupported) return;

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    // The Darwin settings default to prompting inside initialize().
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _plugin.initialize(settings: settings);
    _initialized = true;
  }

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  IOSFlutterLocalNotificationsPlugin? get _ios => _plugin
      .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin
      >();

  Future<bool> areNotificationsEnabled() async {
    if (!isSupported) return false;
    await init();
    final android = _android;
    if (android != null) {
      return await android.areNotificationsEnabled() ?? false;
    }
    final permissions = await _ios?.checkPermissions();
    return permissions?.isEnabled ?? false;
  }

  /// Shows the OS permission prompt (a no-op if the user already decided —
  /// the OS won't ask again). Returns whether notifications are allowed.
  Future<bool> requestPermission() async {
    if (!isSupported) return false;
    await init();
    final android = _android;
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    return await _ios?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ??
        false;
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

  Future<void> cancelAll() async {
    if (!isSupported) return;
    await _plugin.cancelAll();
  }
}
