import 'auth_service.dart';
import 'notification_service.dart';
import 'pet_service.dart';
import 'storage_service.dart';

/// Permanently deletes the signed-in user and everything they own.
///
/// Order is the whole design: the password is re-checked first so a typo
/// deletes nothing, and the Firebase Auth user is deleted LAST. If the app
/// is killed or loses signal part-way, the account still exists — the user
/// can sign in and retry, and nothing is left orphaned out of their reach.
///
/// What gets deleted:
/// - users/{uid}/pets/{petId} and every [PetService.petSubcollections]
/// - every Storage object under users/{uid}/
/// - reminders scheduled on this device
/// - the users/{uid} profile document
/// - the Firebase Auth user
class AccountDeletionService {
  final AuthService _auth;
  final PetService _pets;
  final StorageService _storage;
  final NotificationService _notifications;

  AccountDeletionService({
    AuthService? authService,
    PetService? petService,
    StorageService? storageService,
    NotificationService? notificationService,
  }) : _auth = authService ?? AuthService(),
       _pets = petService ?? PetService(),
       _storage = storageService ?? StorageService(),
       _notifications = notificationService ?? NotificationService();

  Future<void> deleteAccount({required String password}) async {
    final userId = _auth.currentUser!.uid;

    // 1. Fail fast on a wrong password, before anything is touched.
    await _auth.reauthenticate(password);

    // 2. Firestore pet data, subcollections first.
    for (final petId in await _pets.petIds(userId)) {
      await _pets.deletePet(userId, petId);
    }

    // 3. Photos — the whole folder, so files orphaned by earlier pet
    //    deletions go too.
    await _storage.deleteFolder('users/$userId');

    // 4. Local reminders for pets that no longer exist.
    await _notifications.cancelAll();

    // 5. Profile document.
    await _auth.deleteProfile(userId);

    // 6. The login itself — last, so every failure above stays retryable.
    await _auth.deleteCurrentUser();
  }
}
