import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';

/// Confirms account deletion with the user's password and runs it.
///
/// Stays open on failure (wrong password, network) so the user can retry,
/// and can't be dismissed mid-deletion. Resolves to true once the account
/// is gone.
class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    final deleted = await showDialog<bool>(
      context: context,
      builder: (_) => const DeleteAccountDialog(),
    );
    return deleted ?? false;
  }

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final _passwordController = TextEditingController();
  bool _isDeleting = false;
  String? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    final password = _passwordController.text;
    if (password.isEmpty || _isDeleting) return;

    final l10n = AppLocalizations.of(context)!;
    final auth = context.read<AuthProvider>();
    setState(() {
      _isDeleting = true;
      _error = null;
    });

    final success = await auth.deleteAccount(password: password);
    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() {
      _isDeleting = false;
      _error = switch (auth.errorCode) {
        'wrong-password' || 'invalid-credential' => l10n.errIncorrectPassword,
        _ => l10n.deleteAccountFailed,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: !_isDeleting,
      child: AlertDialog(
        title: Text(l10n.deleteAccountTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.deleteAccountMessage),
              const SizedBox(height: 12),
              Text(
                l10n.deleteAccountSubscriptionNote,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                enabled: !_isDeleting,
                autofillHints: const [AutofillHints.password],
                onSubmitted: (_) => _delete(),
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: l10n.confirmPasswordToDelete,
                  errorText: _error,
                  errorMaxLines: 4,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isDeleting ? null : () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            onPressed: _isDeleting || _passwordController.text.isEmpty
                ? null
                : _delete,
            child: _isDeleting
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: colorScheme.onError,
                    ),
                  )
                : Text(l10n.deleteAccountConfirm),
          ),
        ],
      ),
    );
  }
}
