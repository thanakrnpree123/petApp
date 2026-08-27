enum TriageLevel { monitor, vet, emergency }

class SymptomOption {
  final String label;
  final String nextNodeId;

  const SymptomOption({required this.label, required this.nextNodeId});
}

sealed class DecisionNode {
  final String id;

  const DecisionNode(this.id);
}

class QuestionNode extends DecisionNode {
  final String questionText;
  final List<SymptomOption> options;

  const QuestionNode({
    required String id,
    required this.questionText,
    required this.options,
  }) : super(id);
}

class ResultNode extends DecisionNode {
  final TriageLevel level;
  final String advice;

  const ResultNode({
    required String id,
    required this.level,
    required this.advice,
  }) : super(id);
}

typedef DecisionTree = Map<String, DecisionNode>;

class SymptomAnswer {
  final String questionId;
  final String questionText;
  final String answer;

  const SymptomAnswer({
    required this.questionId,
    required this.questionText,
    required this.answer,
  });
}
