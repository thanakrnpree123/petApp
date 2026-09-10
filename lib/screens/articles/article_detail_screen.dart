import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/article.dart';
import '../../theme/app_theme.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final paragraphs = article.content
        .split('\n\n')
        .where((p) => p.trim().isNotEmpty);

    return Scaffold(
      appBar: AppBar(title: Text(article.categoryLabel)),
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
                  child: Image.network(article.imageUrl!, fit: BoxFit.cover),
                ),
                const SizedBox(height: 20),
              ],
              Text(
                article.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat.yMMMd().format(article.publishedAt),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
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
            ],
          ),
        ),
      ),
    );
  }
}
