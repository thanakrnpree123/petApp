import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/subscription_provider.dart';
import '../../widgets/settings/language_dialog.dart';
import '../subscription/paywall_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isPlusMember = context.watch<SubscriptionProvider>().isPlusMember;
    final email = FirebaseAuth.instance.currentUser?.email ?? '—';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          l10n.account,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 8),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.email_outlined),
          title: Text(l10n.email),
          subtitle: Text(email),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            isPlusMember
                ? Icons.workspace_premium
                : Icons.workspace_premium_outlined,
            color: isPlusMember ? Colors.amber[700] : null,
          ),
          title: Text(l10n.subscription),
          subtitle: Text(isPlusMember ? l10n.pawHealthPlus : l10n.freeTier),
          trailing: isPlusMember
              ? null
              : TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const PaywallScreen()),
                    );
                  },
                  child: Text(l10n.upgrade),
                ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.language),
          title: Text(l10n.language),
          subtitle: Text(
            LocaleProvider.endonym(context.watch<LocaleProvider>().locale),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => LanguageDialog.show(context),
        ),
        const SizedBox(height: 24),
        FilledButton.tonalIcon(
          onPressed: () => context.read<AuthProvider>().signOut(),
          icon: const Icon(Icons.logout),
          label: Text(l10n.logOut),
        ),
      ],
    );
  }
}
