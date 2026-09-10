import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/data/decision_trees/cat_not_eating_tree.dart';
import 'package:pawhealth/data/decision_trees/cat_urinary_tree.dart';
import 'package:pawhealth/data/decision_trees/cat_vomiting_tree.dart';
import 'package:pawhealth/data/decision_trees/decision_tree.dart';
import 'package:pawhealth/data/decision_trees/limping_tree.dart';
import 'package:pawhealth/data/decision_trees/symptom_catalog.dart';
import 'package:pawhealth/data/decision_trees/toxin_tree.dart';
import 'package:pawhealth/l10n/app_localizations.dart';
import 'package:pawhealth/l10n/app_localizations_en.dart';
import 'package:pawhealth/l10n/app_localizations_th.dart';
import 'package:pawhealth/l10n/app_localizations_zh.dart';
import 'package:pawhealth/services/symptom_checker.dart';
import 'package:pawhealth/utils/l10n_helpers.dart';

void main() {
  group('symptom catalog structure', () {
    for (final symptom in symptomCatalog) {
      test('${symptom.id}: every node is reachable and ends in a result', () {
        final tree = symptom.tree;
        expect(tree[symptom.startNodeId], isA<QuestionNode>());

        final visited = <String>{};
        void walk(String nodeId) {
          if (!visited.add(nodeId)) return;
          final node = tree[nodeId];
          expect(node, isNotNull, reason: 'Dangling node id: $nodeId');
          expect(node!.id, nodeId, reason: 'Map key and node id differ');
          if (node is QuestionNode) {
            expect(node.options, isNotEmpty, reason: '$nodeId has no options');
            for (final option in node.options) {
              walk(option.nextNodeId);
            }
          }
        }

        walk(symptom.startNodeId);
        expect(
          tree.keys.toSet().difference(visited),
          isEmpty,
          reason: 'Unreachable nodes',
        );
      });

      test('${symptom.id}: can reach an emergency outcome', () {
        // Every symptom must be able to escalate — a tree that can only
        // ever say "monitor" would be dangerous by construction.
        expect(
          symptom.tree.values.whereType<ResultNode>().map((n) => n.level),
          contains(TriageLevel.emergency),
        );
      });
    }

    test('node ids are unique across all trees', () {
      // L10nHelpers maps node id -> translation in one switch, so a
      // collision would silently show one tree's text in another.
      final seen = <String, String>{};
      for (final symptom in symptomCatalog) {
        // Two catalog entries may share one tree only if they're the
        // same object; distinct trees must not reuse ids.
        for (final id in symptom.tree.keys) {
          final owner = seen[id];
          expect(
            owner == null || owner == symptom.id,
            isTrue,
            reason: '"$id" used in both $owner and ${symptom.id}',
          );
          seen[id] = symptom.id;
        }
      }
    });

    test('species filtering', () {
      expect(symptomsForSpecies('dog'), hasLength(6));
      expect(symptomsForSpecies('cat'), hasLength(6));
      expect(
        symptomsForSpecies('cat').map((s) => s.id),
        contains(catUrinarySymptomId),
      );
      expect(
        symptomsForSpecies('dog').map((s) => s.id),
        isNot(contains(catUrinarySymptomId)),
      );
      expect(symptomsForSpecies('rabbit'), isEmpty);
    });
  });

  group('translations', () {
    final en = AppLocalizationsEn();
    final translated = <String, AppLocalizations>{
      'th': AppLocalizationsTh(),
      'zh': AppLocalizationsZh(),
    };

    for (final symptom in symptomCatalog) {
      test('${symptom.id}: English ARB matches the canonical tree text', () {
        // Canonical English is stored in Firestore and shared with vets;
        // the ARB copy must not drift from it.
        for (final node in symptom.tree.values) {
          switch (node) {
            case QuestionNode():
              expect(L10nHelpers.question(en, node), node.questionText);
              for (final option in node.options) {
                expect(L10nHelpers.option(en, option), option.label);
              }
            case ResultNode():
              expect(L10nHelpers.advice(en, node), node.advice);
          }
        }
      });

      for (final MapEntry(key: lang, value: l10n) in translated.entries) {
        test('${symptom.id}: every string is translated to $lang', () {
          expect(
            L10nHelpers.symptomName(l10n, symptom.id),
            isNot(symptom.name),
          );
          for (final node in symptom.tree.values) {
            switch (node) {
              case QuestionNode():
                expect(
                  L10nHelpers.question(l10n, node),
                  isNot(node.questionText),
                  reason: 'Untranslated question ${node.id}',
                );
                for (final option in node.options) {
                  expect(
                    L10nHelpers.option(l10n, option),
                    isNot(option.label),
                    reason: 'Untranslated option "${option.label}"',
                  );
                }
              case ResultNode():
                expect(
                  L10nHelpers.advice(l10n, node),
                  isNot(node.advice),
                  reason: 'Untranslated advice ${node.id}',
                );
            }
          }
        });
      }
    }
  });

  group('clinical red flags escalate', () {
    TriageLevel run(DecisionTree tree, String start, List<String> labels) {
      final checker = SymptomChecker(tree, startNodeId: start);
      for (final label in labels) {
        final node = checker.currentNode as QuestionNode;
        checker.answer(node.options.firstWhere((o) => o.label == label));
      }
      expect(checker.isComplete, isTrue);
      return checker.result.level;
    }

    test('cat straining with no urine is an emergency', () {
      expect(run(catUrinaryTree, 'cu_start', ['Yes']), TriageLevel.emergency);
    });

    test('a cat that stops eating screens for urinary blockage first', () {
      expect(
        run(catNotEatingTree, 'cn_start', ['No', 'Yes']),
        TriageLevel.emergency,
      );
    });

    test('a cat not eating for over 24 hours needs a vet', () {
      expect(
        run(catNotEatingTree, 'cn_start', ['No', 'No', 'More than 24 hours']),
        TriageLevel.vet,
      );
    });

    test('swallowed string or lily in a cat is an emergency', () {
      expect(
        run(catVomitingTree, 'cv_start', ['1 time', 'No', 'Yes']),
        TriageLevel.emergency,
      );
    });

    test('a known toxin is an emergency even without symptoms', () {
      for (final label in [
        'Human medication',
        'Chocolate, xylitol, grapes, raisins, onions, or garlic',
        'Lilies or another toxic plant',
        'Rat poison, antifreeze, or household chemicals',
      ]) {
        expect(
          run(toxinTree, 'tx_start', ['No', label]),
          TriageLevel.emergency,
          reason: label,
        );
      }
    });

    test('a pet holding a leg up needs a vet', () {
      expect(
        run(limpingTree, 'lm_start', ['No', 'No', 'No, they hold the leg up']),
        TriageLevel.vet,
      );
    });
  });
}
