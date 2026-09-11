import 'decision_tree.dart';

const String catNotEatingSymptomId = 'not_eating_cat';

final DecisionTree catNotEatingTree = {
  'cn_start': const QuestionNode(
    id: 'cn_start',
    questionText:
        'Has your pet collapsed, or are their gums pale, white, grey, or blue?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'cn_result_emergency_collapse'),
      SymptomOption(label: 'No', nextNodeId: 'cn_urinary'),
    ],
  ),
  // A blocked bladder often shows up first as "not eating", so it's
  // screened for before anything else.
  'cn_urinary': const QuestionNode(
    id: 'cn_urinary',
    questionText:
        'Is your cat straining in the litter box but passing little or no urine?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'cn_result_emergency_urinary'),
      SymptomOption(label: 'No', nextNodeId: 'cn_duration'),
    ],
  ),
  'cn_duration': const QuestionNode(
    id: 'cn_duration',
    questionText: 'How long has your cat not been eating?',
    options: [
      SymptomOption(label: 'Less than 24 hours', nextNodeId: 'cn_signs'),
      SymptomOption(
        label: 'More than 24 hours',
        nextNodeId: 'cn_result_vet_fasting',
      ),
    ],
  ),
  'cn_signs': const QuestionNode(
    id: 'cn_signs',
    questionText:
        'Is your cat also vomiting, hiding, or much less active than usual?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'cn_result_vet_signs'),
      SymptomOption(label: 'No', nextNodeId: 'cn_result_monitor'),
    ],
  ),
  'cn_result_emergency_collapse': const ResultNode(
    id: 'cn_result_emergency_collapse',
    level: TriageLevel.emergency,
    advice:
        'Collapse or pale, white, grey, or blue gums can signal shock, blood loss, or a breathing problem. Go to an emergency vet immediately.',
  ),
  'cn_result_emergency_urinary': const ResultNode(
    id: 'cn_result_emergency_urinary',
    level: TriageLevel.emergency,
    advice:
        'Straining to pee with little or nothing coming out can mean a urinary blockage — a life-threatening emergency, especially in male cats. Go to an emergency vet now.',
  ),
  'cn_result_vet_fasting': const ResultNode(
    id: 'cn_result_vet_fasting',
    level: TriageLevel.vet,
    advice:
        'Cats that go without food for more than a day are at risk of fatty liver disease (hepatic lipidosis), which can be life-threatening. Have your cat seen by a vet today.',
  ),
  'cn_result_vet_signs': const ResultNode(
    id: 'cn_result_vet_signs',
    level: TriageLevel.vet,
    advice:
        'Not eating along with vomiting, hiding, or low energy should be checked by a vet today.',
  ),
  'cn_result_monitor': const ResultNode(
    id: 'cn_result_monitor',
    level: TriageLevel.monitor,
    advice:
        "A cat that has skipped a meal but is otherwise acting normally can be watched closely at home. Offer fresh food and water, and contact a vet if they haven't eaten within 24 hours.",
  ),
};
