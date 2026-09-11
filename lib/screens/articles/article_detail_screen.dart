import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/article.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_dates.dart';
import '../../utils/l10n_helpers.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final language = Localizations.localeOf(context).languageCode;
    final paragraphs = article.content
        .of(language)
        .split('\n\n')
        .where((p) => p.trim().isNotEmpty);
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;

    return Scaffold(
      appBar: AppBar(title: Text(L10nHelpers.articleCategory(l10n, article))),
      body: Align(
        alignment: Alignment.topCenter,
        // Capped to a comfortable reading measure on wide screens.
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: [
              if (article.imageUrl != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: Image.network(
                    article.imageUrl!,
                    // New URL → new <img> element (see PetAvatar).
                    key: ValueKey(article.imageUrl),
                    fit: BoxFit.cover,
                    // Article images may be hosted without CORS headers.
                    webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              Text(
                article.title.of(language),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                AppDates.medium(context).format(article.publishedAt),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: muted),
              ),
              const SizedBox(height: 20),
              for (final paragraph in paragraphs) ...[
                Text(
                  paragraph,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(height: 1.65),
                ),
                const SizedBox(height: 16),
              ],
              const Divider(height: 32),
              Text(
                l10n.articleDisclaimer,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
