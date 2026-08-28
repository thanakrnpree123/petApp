import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Shared "Are you sure?" confirmation used before any destructive delete.
/// Defaults to the generic record-delete copy; pass [title]/[message] to
/// tailor the wording for a specific kind of item (e.g. a pet profile).
class ConfirmDeleteDialog extends StatelessWidget {
  final String? title;
  final String? message;

  const ConfirmDeleteDialog({super.key, this.title, this.message});

  static Future<bool> show(
    BuildContext context, {
    String? title,
    String? message,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDeleteDialog(title: title, message: message),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(title ?? l10n.deleteRecordTitle),
      content: Text(message ?? l10n.deleteConfirmMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.delete),
        ),
      ],
    );
  }
}
