import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/data/decision_trees/decision_tree.dart';
import 'package:pawhealth/data/decision_trees/dog_vomiting_tree.dart';
import 'package:pawhealth/services/symptom_checker.dart';

void main() {
  group('SymptomChecker with dogVomitingTree', () {
    test('4+ vomits routes straight to emergency', () {
      final checker = SymptomChecker(dogVomitingTree);
      checker.answer(
        (checker.currentNode as QuestionNode).options.firstWhere(
          (o) => o.label == '4 or more times',
        ),
      );

      expect(checker.isComplete, isTrue);
      expect(checker.result.level, TriageLevel.emergency);
      expect(checker.path, hasLength(1));
    });

    test('single episode, no red flags, resolves to monitor', () {
      final checker = SymptomChecker(dogVomitingTree);
      _answerByLabel(checker, '1 time');
      _answerByLabel(checker, 'No'); // blood
      _answerByLabel(checker, 'No'); // lethargy
      _answerByLabel(checker, 'No'); // toxin

      expect(checker.isComplete, isTrue);
      expect(checker.result.level, TriageLevel.monitor);
      expect(checker.path, hasLength(4));
    });

    test('blood in vomit is always emergency regardless of frequency', () {
      final checker = SymptomChecker(dogVomitingTree);
      _answerByLabel(checker, '2-3 times');
      _answerByLabel(checker, 'Yes'); // blood

      expect(checker.isComplete, isTrue);
      expect(checker.result.level, TriageLevel.emergency);
    });

    test('goBack rewinds one question and clears the completed state', () {
      final checker = SymptomChecker(dogVomitingTree);
      _answerByLabel(checker, '1 time');
      _answerByLabel(checker, 'No'); // blood -> lethargy_check_mild
      expect(checker.path, hasLength(2));

      checker.goBack();

      expect(checker.path, hasLength(1));
      expect(checker.isComplete, isFalse);
      expect((checker.currentNode as QuestionNode).id, 'blood_check_mild');
    });

    test('no-symptoms path resolves immediately to the healthy result', () {
      final checker = SymptomChecker(dogVomitingTree);
      _answerByLabel(checker, 'No symptoms / General checkup');

      expect(checker.isComplete, isTrue);
      expect(checker.result.id, 'result_healthy');
      expect(checker.result.level, TriageLevel.monitor);
      expect(checker.path, hasLength(1));
    });

    test('every node reachable from start terminates in a ResultNode', () {
      void walk(String nodeId, Set<String> visited) {
        if (!visited.add(nodeId)) return;
        final node = dogVomitingTree[nodeId];
        expect(node, isNotNull, reason: 'Dangling node id: $nodeId');
        if (node is QuestionNode) {
          for (final option in node.options) {
            walk(option.nextNodeId, visited);
          }
        }
      }

      final visited = <String>{};
      walk('start', visited);

      final resultNodes = visited.where(
        (id) => dogVomitingTree[id] is ResultNode,
      );
      expect(resultNodes, isNotEmpty);
    });
  });
}

void _answerByLabel(SymptomChecker checker, String label) {
  final node = checker.currentNode as QuestionNode;
  checker.answer(node.options.firstWhere((o) => o.label == label));
}
