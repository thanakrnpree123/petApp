import 'decision_tree.dart';

/// Shared by dogs and cats — the wording says "your pet" throughout.
const String breathingSymptomId = 'breathing';

final DecisionTree breathingTree = {
  'br_start': const QuestionNode(
    id: 'br_start',
    questionText:
        'Has your pet collapsed, or are their gums pale, white, grey, or blue?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'br_result_emergency_collapse'),
      SymptomOption(label: 'No', nextNodeId: 'br_heat'),
    ],
  ),
  'br_heat': const QuestionNode(
    id: 'br_heat',
    questionText:
        'Has your pet been in a hot car, out in the sun, or exercising in hot weather — and are they panting heavily or drooling?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'br_result_emergency_heat'),
      SymptomOption(label: 'No', nextNodeId: 'br_effort'),
    ],
  ),
  'br_effort': const QuestionNode(
    id: 'br_effort',
    questionText:
        'Is your pet struggling to breathe while resting — breathing fast, with visible effort, or (for cats) with their mouth open?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'br_result_emergency_breathing'),
      SymptomOption(label: 'No', nextNodeId: 'br_cough'),
    ],
  ),
  'br_cough': const QuestionNode(
    id: 'br_cough',
    questionText:
        'Is your pet coughing, sneezing, or does it have a runny nose?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'br_unwell'),
      SymptomOption(label: 'No', nextNodeId: 'br_result_monitor'),
    ],
  ),
  'br_unwell': const QuestionNode(
    id: 'br_unwell',
    questionText:
        'Is your pet also eating less or low on energy, or has this lasted more than 3 days?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'br_result_vet'),
      SymptomOption(label: 'No', nextNodeId: 'br_result_monitor_cough'),
    ],
  ),
  'br_result_emergency_collapse': const ResultNode(
    id: 'br_result_emergency_collapse',
    level: TriageLevel.emergency,
    advice:
        'Collapse or pale, white, grey, or blue gums can signal shock, blood loss, or a breathing problem. Go to an emergency vet immediately.',
  ),
  'br_result_emergency_heat': const ResultNode(
    id: 'br_result_emergency_heat',
    level: TriageLevel.emergency,
    advice:
        'This may be heatstroke, which can be fatal. Move your pet somewhere cool, wet their coat with cool (not ice-cold) water, and go to an emergency vet immediately.',
  ),
  'br_result_emergency_breathing': const ResultNode(
    id: 'br_result_emergency_breathing',
    level: TriageLevel.emergency,
    advice:
        'Struggling to breathe at rest is an emergency. Keep your pet calm and cool, and go to an emergency vet now. Cats should never breathe with their mouth open.',
  ),
  'br_result_vet': const ResultNode(
    id: 'br_result_vet',
    level: TriageLevel.vet,
    advice:
        'Coughing or sneezing with low energy or a poor appetite, or that has lasted more than a few days, should be checked by a vet within 1–2 days.',
  ),
  'br_result_monitor_cough': const ResultNode(
    id: 'br_result_monitor_cough',
    level: TriageLevel.monitor,
    advice:
        'A mild cough or sneeze in a pet that is eating and active can usually be watched at home. Keep them rested, away from smoke and dust, and see a vet if it gets worse or lasts more than 3 days.',
  ),
  'br_result_monitor': const ResultNode(
    id: 'br_result_monitor',
    level: TriageLevel.monitor,
    advice:
        'No urgent breathing warning signs right now. Resting breathing should be quiet and easy — if your pet starts breathing fast or with effort while resting, treat it as an emergency.',
  ),
};
