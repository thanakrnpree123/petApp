import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/l10n/app_localizations_en.dart';
import 'package:pawhealth/models/article.dart';
import 'package:pawhealth/utils/l10n_helpers.dart';

/// Keeps tool/seed_articles/articles.json in step with the app.
void main() {
  final articles =
      (jsonDecode(File('tool/seed_articles/articles.json').readAsStringSync())
              as Map<String, dynamic>)['articles']
          as List<dynamic>;
  final en = AppLocalizationsEn();

  test('every starter article records who reviewed it, if anyone', () {
    expect(articles, hasLength(greaterThanOrEqualTo(6)));
    for (final a in articles.cast<Map<String, dynamic>>()) {
      if (a['vet_reviewed'] == true) {
        expect(a['reviewed_by'], isA<String>(), reason: a['id'] as String);
      }
    }
  });

  for (final raw in articles.cast<Map<String, dynamic>>()) {
    final id = raw['id'] as String;
    final article = Article(
      id: id,
      title: LocalizedText.fromFirestore(raw['title']),
      category: raw['category'] as String,
      content: LocalizedText.fromFirestore(raw['content']),
      publishedAt: DateTime.parse(raw['published_at'] as String),
    );

    test('$id: its category has a translated label', () {
      // Not the title-cased fallback: one of the ARB labels.
      final label = L10nHelpers.articleCategory(en, article);
      expect([
        en.articleCatFirstAid,
        en.articleCatSafety,
        en.articleCatPreventiveCare,
        en.articleCatNutrition,
        en.articleCatSymptoms,
      ], contains(label));
    });

    test('$id: every language has its own title and body', () {
      for (final lang in ['en', 'th', 'zh']) {
        final map = raw['title'] as Map<String, dynamic>;
        expect(map[lang], isA<String>(), reason: '$id title.$lang');
        expect(
          (raw['content'] as Map<String, dynamic>)[lang],
          isA<String>(),
          reason: '$id content.$lang',
        );
      }
      // Not a silent fallback to English.
      expect(article.title.of('th'), isNot(article.title.of('en')));
      expect(article.content.of('zh'), isNot(article.content.of('en')));
    });
  }
}
