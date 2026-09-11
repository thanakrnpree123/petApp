import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/app_localizations.dart';
import '../../services/notification_service.dart';

/// Asks for notification permission at the moment it makes sense: right
/// after the user adds a vaccine that a reminder can be scheduled for.
///
/// An in-app explainer comes first, and the OS prompt only follows a
/// "Turn On" — iOS shows its prompt once per install, so it must not be
/// spent on a user who'd tap "Don't Allow". The explainer itself is shown
/// at most once; after a "Not now" the user can still enable reminders in
/// their phone's settings.
abstract final class ReminderPermissionPrompt {
  @visibleForTesting
  static const askedKey = 'reminder_permission_asked';

  static Future<void> maybeAsk(
    BuildContext context, {
    required String petName,
    NotificationService? notificationService,
  }) async {
    if (!NotificationService.isSupported) return;
    final notifications = notificationService ?? NotificationService();

    if (await notifications.areNotificationsEnabled()) return;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(askedKey) ?? false) return;
    if (!context.mounted) return;

    final l10n = AppLocalizations.of(context)!;
    final turnOn = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          Icons.notifications_active_outlined,
          size: 40,
          color: Theme.of(dialogContext).colorScheme.primary,
        ),
        title: Text(l10n.reminderPromptTitle),
        content: Text(l10n.reminderPromptMessage(petName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.notNow),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.turnOnReminders),
          ),
        ],
      ),
    );

    await prefs.setBool(askedKey, true);
    if (turnOn ?? false) await notifications.requestPermission();
  }
}
