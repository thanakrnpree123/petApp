import 'decision_tree.dart';

const String catUrinarySymptomId = 'urinary_cat';

final DecisionTree catUrinaryTree = {
  'cu_start': const QuestionNode(
    id: 'cu_start',
    questionText:
        'Is your cat straining in the litter box but passing little or no urine?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'cu_result_emergency_blocked'),
      SymptomOption(label: 'No', nextNodeId: 'cu_blood'),
    ],
  ),
  'cu_blood': const QuestionNode(
    id: 'cu_blood',
    questionText:
        'Is there blood in the urine, or is your cat crying out in the litter box or licking their genitals a lot?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'cu_result_vet_pain'),
      SymptomOption(label: 'No', nextNodeId: 'cu_frequency'),
    ],
  ),
  'cu_frequency': const QuestionNode(
    id: 'cu_frequency',
    questionText:
        'Is your cat peeing more often than usual, or outside the litter box?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'cu_thirst'),
      SymptomOption(label: 'No', nextNodeId: 'cu_result_monitor'),
    ],
  ),
  'cu_thirst': const QuestionNode(
    id: 'cu_thirst',
    questionText: 'Is your cat also drinking much more water than usual?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'cu_result_vet_thirst'),
      SymptomOption(label: 'No', nextNodeId: 'cu_result_vet_behavior'),
    ],
  ),
  'cu_result_emergency_blocked': const ResultNode(
    id: 'cu_result_emergency_blocked',
    level: TriageLevel.emergency,
    advice:
        'Straining to pee with little or nothing coming out can mean a urinary blockage — a life-threatening emergency, especially in male cats. Go to an emergency vet now.',
  ),
  'cu_result_vet_pain': const ResultNode(
    id: 'cu_result_vet_pain',
    level: TriageLevel.vet,
    advice:
        'Blood in the urine, pain, or frequent licking can point to cystitis or a urinary infection. Have your cat seen by a vet today — and if they start straining with no urine, treat it as an emergency.',
  ),
  'cu_result_vet_thirst': const ResultNode(
    id: 'cu_result_vet_thirst',
    level: TriageLevel.vet,
    advice:
        'Drinking and peeing more than usual can be a sign of kidney disease, diabetes, or thyroid problems. Book a vet visit within the next few days.',
  ),
  'cu_result_vet_behavior': const ResultNode(
    id: 'cu_result_vet_behavior',
    level: TriageLevel.vet,
    advice:
        'Peeing more often or outside the box can be caused by a urinary problem or by stress. Book a vet visit within a few days, and keep the litter box clean and easy to reach.',
  ),
  'cu_result_monitor': const ResultNode(
    id: 'cu_result_monitor',
    level: TriageLevel.monitor,
    advice:
        'No urgent urinary warning signs right now. Keep watching the litter box — straining with little or no urine is always an emergency.',
  ),
};
