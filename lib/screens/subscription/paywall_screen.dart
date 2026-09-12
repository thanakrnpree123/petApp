import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../config/legal_links.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/subscription_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/l10n_helpers.dart';
import '../../widgets/common/legal_link.dart';
import '../../widgets/common/paw_loader.dart';

class PaywallScreen extends StatelessWidget {
  /// Override for tests; opens links in the browser by default.
  final UrlOpener? openUrl;

  const PaywallScreen({super.key, this.openUrl});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final subscription = context.watch<SubscriptionProvider>();
    final package = subscription.currentPackage;

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
                          // Only the store's real, localized price — a
                          // hardcoded "\$2.99" is wrong in baht or yuan.
                          if (package != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              l10n.monthlyPrice(
                                package.storeProduct.priceString,
                              ),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(color: colorScheme.primary),
                            ),
                          ],
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
                          const Spacer(),
                          _PurchaseActions(
                            subscription: subscription,
                            package: package,
                          ),
                          _LegalFooter(
                            // Subscription terms belong wherever a
                            // subscription can actually be bought.
                            price:
                                subscription.availability ==
                                    PurchaseAvailability.available
                                ? package?.storeProduct.priceString
                                : null,
                            openUrl: openUrl,
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

/// The bottom of the paywall: the buy buttons when a subscription can be
/// sold, otherwise an explanation (and a retry where one could help) —
/// never a disabled button with no reason given.
class _PurchaseActions extends StatelessWidget {
  final SubscriptionProvider subscription;
  final Package? package;

  const _PurchaseActions({required this.subscription, required this.package});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return switch (subscription.availability) {
      PurchaseAvailability.available => _buyButtons(context, l10n, colorScheme),
      PurchaseAvailability.loading => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      ),
      PurchaseAvailability.loadFailed => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Notice(text: l10n.errSubscriptionLoad),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: subscription.retry,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.tryAgain),
          ),
        ],
      ),
      PurchaseAvailability.mobileOnly => _Notice(
        icon: Icons.phone_iphone,
        text: l10n.paywallMobileOnly,
      ),
      PurchaseAvailability.unavailable => _Notice(
        text: l10n.paywallUnavailable,
      ),
    };
  }

  Widget _buyButtons(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    final package = this.package!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (subscription.errorCode != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              L10nHelpers.subscriptionError(l10n, subscription.errorCode!),
              style: TextStyle(color: colorScheme.error),
            ),
          ),
        FilledButton(
          onPressed: subscription.isLoading
              ? null
              : () async {
                  final success = await PawLoaderOverlay.during(
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
                  final success = await PawLoaderOverlay.during(
                    context,
                    subscription.restore(),
                    message: l10n.restoringPurchases,
                  );
                  if (success && context.mounted && subscription.isPlusMember) {
                    Navigator.of(context).pop();
                  }
                },
          child: Text(l10n.restorePurchases),
        ),
      ],
    );
  }
}

class _Notice extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Notice({this.icon = Icons.info_outline, required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(child: Text(text)),
          ],
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

/// What the stores require under a subscription offer: the renewal terms
/// (price, auto-renewal, how to cancel) and working links to the Terms of
/// Use and Privacy Policy (App Store guideline 3.1.2, Google Play's
/// subscriptions policy).
class _LegalFooter extends StatelessWidget {
  /// The price being offered, or null when nothing can be bought here.
  final String? price;
  final UrlOpener? openUrl;

  const _LegalFooter({required this.price, this.openUrl});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final price = this.price;
    final disclosure = price == null
        ? null
        : switch (theme.platform) {
            TargetPlatform.iOS ||
            TargetPlatform.macOS => l10n.autoRenewDisclosureApple(price),
            TargetPlatform.android => l10n.autoRenewDisclosureGoogle(price),
            _ => null,
          };

    Widget link(String label, Uri url) => TextButton(
      style: TextButton.styleFrom(
        visualDensity: VisualDensity.compact,
        textStyle: theme.textTheme.bodySmall?.copyWith(
          decoration: TextDecoration.underline,
        ),
      ),
      onPressed: () => openLegalLink(context, url, opener: openUrl),
      child: Text(label),
    );

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          if (disclosure != null)
            Text(disclosure, textAlign: TextAlign.center, style: muted),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              link(l10n.termsOfUse, LegalLinks.termsOfUse),
              Text('·', style: muted),
              link(l10n.privacyPolicy, LegalLinks.privacyPolicy),
            ],
          ),
        ],
      ),
    );
  }
}
