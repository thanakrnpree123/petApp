import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/article.dart';
import '../../services/article_service.dart';
import '../../widgets/articles/article_card.dart';
import '../../widgets/common/paw_loader.dart';
import 'article_detail_screen.dart';

class ArticleListScreen extends StatefulWidget {
  /// Override for tests; production uses the real service.
  final ArticleService? articleService;

  const ArticleListScreen({super.key, this.articleService});

  @override
  State<ArticleListScreen> createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  late final _service = widget.articleService ?? ArticleService();

  // Created once: a new stream per build() — i.e. per category-chip tap —
  // made the StreamBuilder reset to "waiting", flashing the loader and
  // re-querying Firestore on every tap.
  late final Stream<List<Article>> _articles = _service.watchArticles();
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Article>>(
      stream: _articles,
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
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(AppLocalizations.of(context)!.filterAll),
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
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final article = filtered[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
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
