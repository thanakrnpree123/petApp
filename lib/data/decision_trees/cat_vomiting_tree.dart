import 'decision_tree.dart';

const String catVomitingSymptomId = 'vomiting_cat';

// The single-episode and repeated-episode branches ask the same questions
// but resolve differently at the end, so each gets its own node ids.
final DecisionTree catVomitingTree = {
  'cv_start': const QuestionNode(
    id: 'cv_start',
    questionText: 'How many times has your cat vomited in the last 24 hours?',
    options: [
      SymptomOption(label: '1 time', nextNodeId: 'cv_blood_single'),
      SymptomOption(label: '2-3 times', nextNodeId: 'cv_blood_repeat'),
      SymptomOption(
        label: '4 or more times',
        nextNodeId: 'cv_result_emergency_frequent',
      ),
    ],
  ),
  'cv_blood_single': const QuestionNode(
    id: 'cv_blood_single',
    questionText:
        'Is there any blood in the vomit (red streaks or coffee-ground appearance)?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'cv_result_emergency_blood'),
      SymptomOption(label: 'No', nextNodeId: 'cv_foreign_single'),
    ],
  ),
  'cv_foreign_single': const QuestionNode(
    id: 'cv_foreign_single',
    questionText:
        'Could your cat have swallowed string, thread, ribbon, a hair tie, or part of a lily plant?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'cv_result_emergency_foreign'),
      SymptomOption(label: 'No', nextNodeId: 'cv_lethargy_single'),
    ],
  ),
  'cv_lethargy_single': const QuestionNode(
    id: 'cv_lethargy_single',
    questionText:
        'Has your cat stopped eating, or are they hiding or much less active than usual?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'cv_result_vet_lethargy'),
      SymptomOption(label: 'No', nextNodeId: 'cv_result_monitor'),
    ],
  ),
  'cv_blood_repeat': const QuestionNode(
    id: 'cv_blood_repeat',
    questionText:
        'Is there any blood in the vomit (red streaks or coffee-ground appearance)?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'cv_result_emergency_blood'),
      SymptomOption(label: 'No', nextNodeId: 'cv_foreign_repeat'),
    ],
  ),
  'cv_foreign_repeat': const QuestionNode(
    id: 'cv_foreign_repeat',
    questionText:
        'Could your cat have swallowed string, thread, ribbon, a hair tie, or part of a lily plant?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'cv_result_emergency_foreign'),
      SymptomOption(label: 'No', nextNodeId: 'cv_lethargy_repeat'),
    ],
  ),
  'cv_lethargy_repeat': const QuestionNode(
    id: 'cv_lethargy_repeat',
    questionText:
        'Has your cat stopped eating, or are they hiding or much less active than usual?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'cv_result_vet_lethargy'),
      SymptomOption(label: 'No', nextNodeId: 'cv_result_vet_repeat'),
    ],
  ),
  'cv_result_emergency_frequent': const ResultNode(
    id: 'cv_result_emergency_frequent',
    level: TriageLevel.emergency,
    advice:
        'Vomiting 4+ times in 24 hours risks serious dehydration. Contact an emergency vet immediately.',
  ),
  'cv_result_emergency_blood': const ResultNode(
    id: 'cv_result_emergency_blood',
    level: TriageLevel.emergency,
    advice:
        'Blood in vomit can indicate internal bleeding or a serious GI issue. Seek emergency veterinary care now.',
  ),
  'cv_result_emergency_foreign': const ResultNode(
    id: 'cv_result_emergency_foreign',
    level: TriageLevel.emergency,
    advice:
        "Swallowed string can badly damage a cat's intestines, and every part of a lily is highly toxic to cats. Go to an emergency vet now — never pull on string you can see.",
  ),
  'cv_result_vet_lethargy': const ResultNode(
    id: 'cv_result_vet_lethargy',
    level: TriageLevel.vet,
    advice:
        'Vomiting with loss of appetite, hiding, or low energy needs a vet visit today — cats that stop eating can develop serious liver problems.',
  ),
  'cv_result_vet_repeat': const ResultNode(
    id: 'cv_result_vet_repeat',
    level: TriageLevel.vet,
    advice:
        "Repeated vomiting should be checked by a vet within 24 hours. Keep fresh water available, and don't withhold food for more than a few hours — cats shouldn't go long without eating.",
  ),
  'cv_result_monitor': const ResultNode(
    id: 'cv_result_monitor',
    level: TriageLevel.monitor,
    advice:
        'A single vomit — often a hairball — in a cat that is still eating and acting normally can usually be watched at home. See a vet if it happens again or other symptoms appear.',
  ),
};
