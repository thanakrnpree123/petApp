import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/article.dart';

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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (article.imageUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(article.imageUrl!, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),
          ],
          Chip(
            label: Text(article.categoryLabel),
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(height: 8),
          Text(article.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            DateFormat.yMMMd().format(article.publishedAt),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          for (final paragraph in paragraphs) ...[
            Text(paragraph, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
