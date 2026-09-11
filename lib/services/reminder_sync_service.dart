import '../models/pet.dart';
import '../models/vaccination.dart';
import 'health_log_service.dart';
import 'notification_service.dart';
import 'pet_service.dart';

/// Rebuilds this device's vaccine reminders from Firestore.
///
/// Reminders are scheduled locally, so they live on one device only: a new
/// phone, a reinstall, a sign-in after sign-out (which clears them), or a
/// vaccine edited on another device all leave the local set stale. Running
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

  Future<void> resync(String userId) async {
    if (!NotificationService.isSupported) return;

    // Read everything BEFORE touching the schedule: if the fetch fails
    // (e.g. offline), the existing reminders stay as they are.
    final reminders = <(Pet, Vaccination)>[];
    for (final pet in await _pets.fetchPets(userId)) {
      for (final vaccination in await _healthLogs.fetchVaccinations(
        userId,
        pet.id!,
      )) {
        reminders.add((pet, vaccination));
      }
    }

    await _notifications.cancelAll();
    for (final (pet, vaccination) in reminders) {
      // Past-due vaccinations are skipped inside scheduleVaccineReminder.
      await _notifications.scheduleVaccineReminder(
        id: NotificationService.vaccineReminderId(vaccination.id!),
        petName: pet.name,
        vaccineName: vaccination.name,
        nextDueDate: vaccination.nextDueDate,
      );
    }
  }
}
