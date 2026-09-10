import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/subscription_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/l10n_helpers.dart';
import '../../widgets/common/paw_loader.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final subscription = context.watch<SubscriptionProvider>();
    final packages =
        subscription.offerings?.current?.availablePackages ?? <Package>[];
    final package = packages.isEmpty ? null : packages.first;

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.pawHealthPlus)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            // Fills the screen (so the Spacer pins the buttons to the
            // bottom) but scrolls on short phones or at large text sizes.
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Icon(
                            Icons.workspace_premium,
                            size: 40,
                            color: context.statusColors.premium,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.upgradeToPlus,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.monthlyPrice(
                              package?.storeProduct.priceString ?? '\$2.99',
                            ),
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(color: colorScheme.primary),
                          ),
                          const SizedBox(height: 24),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Column(
                                children: [
                                  _BenefitRow(
                                    icon: Icons.check_circle,
                                    text: l10n.unlimitedSymptomChecks,
                                  ),
                                  _BenefitRow(
                                    icon: Icons.check_circle,
                                    text: l10n.unlimitedPdfReports,
                                  ),
                                  _BenefitRow(
                                    icon: Icons.check_circle,
                                    text: l10n.adFreeExperience,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            l10n.freeTierIncludes,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 8),
                          _BenefitRow(
                            icon: Icons.remove_circle_outline,
                            text: l10n.freeChecksPerMonth,
                            muted: true,
                          ),
                          _BenefitRow(
                            icon: Icons.remove_circle_outline,
                            text: l10n.containsAds,
                            muted: true,
                          ),
                          const Spacer(),
                          if (subscription.errorCode != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                L10nHelpers.subscriptionError(
                                  l10n,
                                  subscription.errorCode!,
                                ),
                                style: TextStyle(color: colorScheme.error),
                              ),
                            ),
                          FilledButton(
                            onPressed: subscription.isLoading || package == null
                                ? null
                                : () async {
                                    final success =
                                        await PawLoaderOverlay.during(
                                          context,
                                          subscription.purchase(package),
                                          message: l10n.processingPurchase,
                                        );
                                    if (success && context.mounted) {
                                      Navigator.of(context).pop();
                                    }
                                  },
                            child: Text(l10n.subscribe),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: subscription.isLoading
                                ? null
                                : () async {
                                    final success =
                                        await PawLoaderOverlay.during(
                                          context,
                                          subscription.restore(),
                                          message: l10n.restoringPurchases,
                                        );
                                    if (success &&
                                        context.mounted &&
                                        subscription.isPlusMember) {
                                      Navigator.of(context).pop();
                                    }
                                  },
                            child: Text(l10n.restorePurchases),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool muted;

  const _BenefitRow({
    required this.icon,
    required this.text,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: muted ? colorScheme.onSurfaceVariant : colorScheme.primary,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: muted ? colorScheme.onSurfaceVariant : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
