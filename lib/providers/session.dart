import '../services/notification_service.dart';
import 'pet_provider.dart';
import 'subscription_provider.dart';

/// Clears everything tied to the signed-in user that would otherwise
/// outlive FirebaseAuth.signOut() — on a shared family device the next
/// person to sign in must not see (or be reminded about) someone else's
/// pets.
///
/// - stops the pets listener (it would otherwise keep running and then
///   fail against the security rules) and clears the list
/// - resets subscription state
/// - cancels this device's vaccine reminders; ReminderSyncService puts the
///   right ones back when a user signs in
Future<void> endUserSession({
  required PetProvider pets,
  required SubscriptionProvider subscription,
  NotificationService? notifications,
}) async {
  pets.stopWatching();
  await subscription.reset();
  await (notifications ?? NotificationService()).cancelAll();
}
