import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/subscription_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/settings/language_dialog.dart';
import '../subscription/paywall_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isPlusMember = context.watch<SubscriptionProvider>().isPlusMember;
    final email = FirebaseAuth.instance.currentUser?.email ?? '—';

    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
              child: Text(
                l10n.account,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: Text(l10n.email),
                    subtitle: Text(email),
                  ),
                  const Divider(indent: 56),
                  ListTile(
                    leading: Icon(
                      isPlusMember
                          ? Icons.workspace_premium
                          : Icons.workspace_premium_outlined,
                      color: isPlusMember ? context.statusColors.premium : null,
                    ),
                    title: Text(l10n.subscription),
                    subtitle: Text(
                      isPlusMember ? l10n.pawHealthPlus : l10n.freeTier,
                    ),
                    trailing: isPlusMember
                        ? null
                        : TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const PaywallScreen(),
                                ),
                              );
                            },
                            child: Text(l10n.upgrade),
                          ),
                  ),
                  const Divider(indent: 56),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(l10n.language),
                    subtitle: Text(
                      LocaleProvider.endonym(
                        context.watch<LocaleProvider>().locale,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => LanguageDialog.show(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.error,
              ),
              onPressed: () => context.read<AuthProvider>().signOut(),
              icon: const Icon(Icons.logout),
              label: Text(l10n.logOut),
            ),
          ],
        ),
      ),
    );
  }
}
