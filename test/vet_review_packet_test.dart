import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/data/decision_trees/decision_tree.dart';
import 'package:pawhealth/data/decision_trees/symptom_catalog.dart';
import 'package:pawhealth/l10n/app_localizations.dart';
import 'package:pawhealth/l10n/app_localizations_en.dart';
import 'package:pawhealth/l10n/app_localizations_th.dart';
import 'package:pawhealth/l10n/app_localizations_zh.dart';
import 'package:pawhealth/utils/l10n_helpers.dart';

import '../tool/vet_review/vet_review_packet.dart';

String _escaped(String s) => s
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');

/// The packet is only useful if a vet sees everything the app can say.
void main() {
  final l10n = <String, AppLocalizations>{
    'en': AppLocalizationsEn(),
    'th': AppLocalizationsTh(),
    'zh': AppLocalizationsZh(),
  };
  final articles =
      (jsonDecode(File('tool/seed_articles/articles.json').readAsStringSync())
              as Map<String, dynamic>)['articles']
          as List<dynamic>;
  final packet = buildVetReviewPacket(
    VetReviewInput(
      l10n: l10n,
      articles: articles.cast<Map<String, dynamic>>(),
      version: 'test',
      generatedAt: DateTime(2026, 9, 12),
    ),
  );

  test('covers every node of every tree', () {
    final nodes = symptomCatalog.fold(0, (n, s) => n + s.tree.length);
    expect(packet.questionCount + packet.outcomeCount, nodes);
  });

  for (final symptom in symptomCatalog) {
    test('${symptom.id}: every question, answer and outcome is in all three '
        'languages', () {
      for (final lang in packetLanguages) {
        final loc = l10n[lang]!;
        for (final node in symptom.tree.values) {
          final texts = switch (node) {
            QuestionNode() => [
              L10nHelpers.question(loc, node),
              for (final o in node.options) L10nHelpers.option(loc, o),
            ],
            ResultNode() => [L10nHelpers.advice(loc, node)],
          };
          for (final text in texts) {
            expect(
              packet.html,
              contains(_escaped(text)),
              reason: '$lang: $text',
            );
          }
        }
      }
    });
  }

  test('every article is in all three languages', () {
    for (final a in articles.cast<Map<String, dynamic>>()) {
      for (final lang in packetLanguages) {
        expect(
          packet.html,
          contains(_escaped((a['title'] as Map)[lang] as String)),
        );
      }
    }
  });

  test('nothing is silently shown in English', () {
    expect(packet.untranslated, isEmpty);
  });

  test('every flow and article ends with an approval box', () {
    final boxes = RegExp('class="approval"').allMatches(packet.html).length;
    expect(boxes, symptomCatalog.length + articles.length);
  });
}
