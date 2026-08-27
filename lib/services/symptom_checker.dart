import '../data/decision_trees/decision_tree.dart';

class SymptomChecker {
  final DecisionTree tree;
  final List<SymptomAnswer> _path = [];
  String _currentNodeId;

  SymptomChecker(this.tree, {String startNodeId = 'start'})
    : _currentNodeId = startNodeId;

  DecisionNode get currentNode => tree[_currentNodeId]!;

  bool get isComplete => currentNode is ResultNode;

  List<SymptomAnswer> get path => List.unmodifiable(_path);

  ResultNode get result {
    final node = currentNode;
    if (node is! ResultNode) {
      throw StateError('SymptomChecker has not reached a result yet.');
    }
    return node;
  }

  void answer(SymptomOption chosen) {
    final node = currentNode;
    if (node is! QuestionNode) {
      throw StateError('SymptomChecker has already reached a result.');
    }
    _path.add(
      SymptomAnswer(
        questionId: node.id,
        questionText: node.questionText,
        answer: chosen.label,
      ),
    );
    _currentNodeId = chosen.nextNodeId;
  }

  void goBack() {
    if (_path.isEmpty) return;
    final last = _path.removeLast();
    _currentNodeId = last.questionId;
  }

  void reset({String startNodeId = 'start'}) {
    _path.clear();
    _currentNodeId = startNodeId;
  }
}
