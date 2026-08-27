import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../screens/subscription/paywall_screen.dart';

class UpgradePromptDialog extends StatelessWidget {
  final String message;

  const UpgradePromptDialog({super.key, required this.message});

  static Future<void> show(BuildContext context, {required String message}) {
    return showDialog<void>(
      context: context,
      builder: (_) => UpgradePromptDialog(message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.workspace_premium, color: Colors.amber[700]),
          const SizedBox(width: 8),
          Expanded(child: Text(l10n.pawHealthPlus)),
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: l10n.close,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.notNow),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const PaywallScreen()));
          },
          child: Text(l10n.upgrade),
        ),
      ],
    );
  }
}
