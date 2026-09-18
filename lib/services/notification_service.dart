import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../l10n/app_localizations.dart';

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

  /// Must be stable across launches and SDK upgrades so a reminder
  /// scheduled today can still be cancelled later — which String.hashCode
  /// doesn't promise. A 31-bit polynomial hash fits the 32-bit ids Android
  /// requires and stays exact under web int math.
  static int _stableId(String key) {
    const modulus = 2147483647; // 2^31 - 1
    var hash = 0;
    for (final unit in key.codeUnits) {
      hash = (hash * 31 + unit) % modulus;
    }
    return hash;
  }

  /// The notification id for a vaccination's reminder, derived from its
  /// Firestore id. Hashes the raw id: reminders scheduled by earlier
  /// versions must keep the same id or they can never be cancelled.
  static int vaccineReminderId(String vaccinationId) =>
      _stableId(vaccinationId);

  /// The notification id for a care record's reminder. Namespaced so a
  /// care log and a vaccination can never collide on one notification id.
  static int careReminderId(String careLogId) => _stableId('care:$careLogId');

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

  /// Local hour reminders are delivered at.
  static const reminderHour = 9;

  /// When to remind about something due on [dueDate]: [reminderHour] on
  /// the day before. If that moment has passed but [reminderHour] on the
  /// due day hasn't (an item added late the day before), remind that
  /// morning instead. Null when both are past.
  ///
  /// Due dates come from a date picker, i.e. local midnight — subtracting a
  /// day from that fired reminders at 00:00.
  static ({DateTime at, bool dueToday})? dueReminderSchedule(
    DateTime dueDate, {
    required DateTime now,
  }) {
    final due = dueDate.toLocal();
    final dayBefore = DateTime(due.year, due.month, due.day - 1, reminderHour);
    if (dayBefore.isAfter(now)) return (at: dayBefore, dueToday: false);

    final dueMorning = DateTime(due.year, due.month, due.day, reminderHour);
    if (dueMorning.isAfter(now)) return (at: dueMorning, dueToday: true);
    return null;
  }

  /// Schedules a reminder for anything with a due date — a vaccination's
  /// next dose, or a care record's next appointment. [itemName] is what
  /// the notification names, e.g. "Rabies" or "Deworming".
  ///
  /// The notification's text is fixed when it's scheduled, so it's
  /// written in [l10n]'s language; ReminderSyncService reschedules
  /// everything when the app language changes.
  Future<void> scheduleDueReminder({
    required int id,
    required String petName,
    required String itemName,
    required DateTime dueDate,
    required AppLocalizations l10n,
  }) async {
    if (!isSupported) return;
    await init();

    final schedule = dueReminderSchedule(dueDate, now: DateTime.now());
    if (schedule == null) return;

    // tz.local defaults to UTC when setLocalLocation() hasn't been called,
    // but TZDateTime.from preserves the real-world instant of the local
    // DateTime it's given, so a one-off schedule still fires at 9:00 AM on
    // the device's clock without detecting the zone name.
    final scheduledDate = tz.TZDateTime.from(schedule.at, tz.local);

    final text = reminderText(l10n, petName, itemName, schedule.dueToday);
    await _plugin.zonedSchedule(
      id: id,
      title: text.title,
      body: text.body,
      scheduledDate: scheduledDate,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          // Care reminders share the vaccination channel: they're the same
          // kind of alert to a user, and a new channel id would orphan the
          // preferences people already set on this one.
          'vaccine_reminders',
          // Android shows these in the app's notification settings; the
          // latest schedule call renames the category to the app language.
          l10n.reminderChannelName,
          channelDescription: l10n.reminderChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  static ({String title, String body}) reminderText(
    AppLocalizations l10n,
    String petName,
    String itemName,
    bool dueToday,
  ) => (
    title: l10n.reminderTitle(petName),
    body: dueToday
        ? l10n.reminderDueToday(itemName)
        : l10n.reminderDueTomorrow(itemName),
  );

  Future<void> cancelReminder(int id) async {
    if (!isSupported) return;
    await _plugin.cancel(id: id);
  }

  Future<void> cancelAll() async {
    if (!isSupported) return;
    await _plugin.cancelAll();
  }
}
