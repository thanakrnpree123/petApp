import '../l10n/app_localizations.dart';
import 'health_log_service.dart';
import 'notification_service.dart';
import 'pet_service.dart';

/// Rebuilds this device's due-date reminders from Firestore — vaccinations
/// and care records (deworming, tick & flea treatment, anything else with a
/// next appointment).
///
/// Reminders are scheduled locally, so they live on one device only: a new
/// phone, a reinstall, a sign-in after sign-out (which clears them), or a
/// record edited on another device all leave the local set stale. Running
/// this on sign-in makes the device match the account.
class ReminderSyncService {
  final PetService _pets;
  final HealthLogService _healthLogs;
  final NotificationService _notifications;

  ReminderSyncService({
    PetService? petService,
    HealthLogService? healthLogService,
    NotificationService? notificationService,
  }) : _pets = petService ?? PetService(),
       _healthLogs = healthLogService ?? HealthLogService(),
       _notifications = notificationService ?? NotificationService();

  /// Reminders are written in [l10n]'s language, so this also runs when
  /// the app language changes.
  Future<void> resync(String userId, {required AppLocalizations l10n}) async {
    if (!NotificationService.isSupported) return;

    // Read everything BEFORE touching the schedule: if the fetch fails
    // (e.g. offline), the existing reminders stay as they are.
    final reminders = <({int id, String petName, String item, DateTime due})>[];
    for (final pet in await _pets.fetchPets(userId)) {
      for (final vaccination in await _healthLogs.fetchVaccinations(
        userId,
        pet.id!,
      )) {
        reminders.add((
          id: NotificationService.vaccineReminderId(vaccination.id!),
          petName: pet.name,
          item: vaccination.name,
          due: vaccination.nextDueDate,
        ));
      }
      for (final log in await _healthLogs.fetchCareLogs(userId, pet.id!)) {
        // Records with no next appointment, or with their reminder turned
        // off, are not meant to alert at all.
        if (!log.hasReminder) continue;
        reminders.add((
          id: NotificationService.careReminderId(log.id!),
          petName: pet.name,
          item: log.title,
          due: log.nextDueDate!,
        ));
      }
    }

    await _notifications.cancelAll();
    for (final reminder in reminders) {
      // Past-due dates are skipped inside scheduleDueReminder.
      await _notifications.scheduleDueReminder(
        id: reminder.id,
        petName: reminder.petName,
        itemName: reminder.item,
        dueDate: reminder.due,
        l10n: l10n,
      );
    }
  }
}
