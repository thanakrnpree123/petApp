import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/article.dart';
import '../../services/article_service.dart';
import '../../widgets/articles/article_card.dart';
import '../../widgets/common/paw_loader.dart';
import 'article_detail_screen.dart';

class ArticleListScreen extends StatefulWidget {
  const ArticleListScreen({super.key});

  @override
  State<ArticleListScreen> createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  final _service = ArticleService();
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Article>>(
      stream: _service.watchArticles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return PawLoader(
            message: AppLocalizations.of(context)!.fetchingArticles,
          );
        }

        final articles = snapshot.data ?? [];
        if (articles.isEmpty) {
          return Center(
            child: Text(AppLocalizations.of(context)!.noArticlesAvailable),
          );
        }

        final categories = articles.map((a) => a.category).toSet().toList()
          ..sort();
        final filtered = _selectedCategory == null
            ? articles
            : articles.where((a) => a.category == _selectedCategory).toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: const Text('All'),
                        selected: _selectedCategory == null,
                        onSelected: (_) =>
                            setState(() => _selectedCategory = null),
                      ),
                    ),
                    for (final category in categories)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(
                            articles
                                .firstWhere((a) => a.category == category)
                                .categoryLabel,
                          ),
                          selected: _selectedCategory == category,
                          onSelected: (_) =>
                              setState(() => _selectedCategory = category),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final article = filtered[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ArticleCard(
                      article: article,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ArticleDetailScreen(article: article),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
