import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../utils/l10n_helpers.dart';
import '../../utils/validators.dart';

/// Sends a password-reset email. Pre-fills whatever the user already typed
/// into the login form, then swaps to a confirmation once the email is sent.
class ForgotPasswordDialog extends StatefulWidget {
  final String initialEmail;

  const ForgotPasswordDialog({super.key, this.initialEmail = ''});

  static Future<void> show(BuildContext context, {String initialEmail = ''}) {
    return showDialog<void>(
      context: context,
      builder: (_) => ForgotPasswordDialog(initialEmail: initialEmail),
    );
  }

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController = TextEditingController(
    text: widget.initialEmail.trim(),
  );
  bool _isSending = false;
  String? _sentTo;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_isSending || !_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final l10n = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;
    setState(() {
      _isSending = true;
      _error = null;
    });

    final errorCode = await context.read<AuthProvider>().sendPasswordReset(
      email: email,
      languageCode: languageCode,
    );
    if (!mounted) return;

    setState(() {
      _isSending = false;
      if (errorCode == null) {
        _sentTo = email;
      } else {
        _error = L10nHelpers.authError(l10n, errorCode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sentTo = _sentTo;

    if (sentTo != null) {
      return AlertDialog(
        icon: Icon(
          Icons.mark_email_read_outlined,
          color: Theme.of(context).colorScheme.primary,
          size: 40,
        ),
        title: Text(l10n.resetPasswordTitle),
        content: Text(l10n.resetLinkSent(sentTo)),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      );
    }

    return AlertDialog(
      title: Text(l10n.resetPasswordTitle),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.resetPasswordMessage),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                enabled: !_isSending,
                autofocus: widget.initialEmail.isEmpty,
                onFieldSubmitted: (_) => _send(),
                validator: (value) => Validators.email(value, l10n),
                decoration: InputDecoration(
                  labelText: l10n.email,
                  errorText: _error,
                  errorMaxLines: 3,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSending ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _isSending ? null : _send,
          child: _isSending
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                )
              : Text(l10n.sendResetLink),
        ),
      ],
    );
  }
}
