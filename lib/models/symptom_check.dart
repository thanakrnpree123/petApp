import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/decision_trees/decision_tree.dart';

class SymptomCheck {
  final String? id;
  final String symptomId;
  final List<SymptomAnswer> answers;
  final TriageLevel triageLevel;
  final String advice;
  final DateTime checkedAt;

  SymptomCheck({
    this.id,
    required this.symptomId,
    required this.answers,
    required this.triageLevel,
    required this.advice,
    required this.checkedAt,
  });

  factory SymptomCheck.fromFirestore(String id, Map<String, dynamic> data) {
    return SymptomCheck(
      id: id,
      symptomId: data['symptom'] as String,
      answers: (data['answers'] as List)
          .map((a) => _answerFromMap(Map<String, dynamic>.from(a as Map)))
          .toList(),
      triageLevel: TriageLevel.values.firstWhere(
        (l) => l.name == data['triage_level'] as String,
      ),
      advice: data['advice'] as String,
      checkedAt: (data['checked_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'symptom': symptomId,
      'answers': answers.map(_answerToMap).toList(),
      'triage_level': triageLevel.name,
      'advice': advice,
      'checked_at': Timestamp.fromDate(checkedAt),
    };
  }

  static Map<String, dynamic> _answerToMap(SymptomAnswer answer) => {
    'question_id': answer.questionId,
    'question_text': answer.questionText,
    'answer': answer.answer,
  };

  static SymptomAnswer _answerFromMap(Map<String, dynamic> map) =>
      SymptomAnswer(
        questionId: map['question_id'] as String,
        questionText: map['question_text'] as String,
        answer: map['answer'] as String,
      );
}
