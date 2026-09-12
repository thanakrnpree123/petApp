import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/legal_links.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/pet_provider.dart';
import '../../providers/session.dart';
import '../../providers/subscription_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/legal_link.dart';
import '../../widgets/responsive/content_width.dart';
import '../../widgets/settings/delete_account_dialog.dart';
import '../../widgets/settings/language_dialog.dart';
import '../subscription/paywall_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _deleteAccount(BuildContext context) async {
    // Captured up front: once the account is gone, AuthWrapper swaps this
    // screen out for the login screen and this context is unmounted.
    final messenger = ScaffoldMessenger.of(context);
    final petProvider = context.read<PetProvider>();
    final subscription = context.read<SubscriptionProvider>();
    final deletedMessage = AppLocalizations.of(context)!.accountDeleted;

    if (!await DeleteAccountDialog.show(context)) return;

    await endUserSession(pets: petProvider, subscription: subscription);
    messenger.showSnackBar(SnackBar(content: Text(deletedMessage)));
  }

  Future<void> _signOut(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    // Before signOut: the pets listener must stop while it still has
    // permission to read, and the next user mustn't inherit any state.
    await endUserSession(
      pets: context.read<PetProvider>(),
      subscription: context.read<SubscriptionProvider>(),
    );
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isPlusMember = context.watch<SubscriptionProvider>().isPlusMember;
    final email = FirebaseAuth.instance.currentUser?.email ?? '—';

    final colorScheme = Theme.of(context).colorScheme;

    final gutter = pageGutter(context);

    return CenteredContent(
      maxWidth: ContentWidth.reading,
      child: ListView(
        padding: EdgeInsets.fromLTRB(gutter, 16, gutter, 32),
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
          const SizedBox(height: 16),
          // Google Play requires the privacy policy inside the app, not
          // only on the store listing.
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: Text(l10n.privacyPolicy),
                  trailing: const Icon(Icons.open_in_new, size: 20),
                  onTap: () => openLegalLink(context, LegalLinks.privacyPolicy),
                ),
                const Divider(indent: 56),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: Text(l10n.termsOfUse),
                  trailing: const Icon(Icons.open_in_new, size: 20),
                  onTap: () => openLegalLink(context, LegalLinks.termsOfUse),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(foregroundColor: colorScheme.error),
            onPressed: () => _signOut(context),
            icon: const Icon(Icons.logout),
            label: Text(l10n.logOut),
          ),
          const SizedBox(height: 8),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: colorScheme.error),
            onPressed: () => _deleteAccount(context),
            child: Text(l10n.deleteAccount),
          ),
        ],
      ),
    );
  }
}
