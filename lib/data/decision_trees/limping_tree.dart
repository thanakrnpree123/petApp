import 'decision_tree.dart';

/// Shared by dogs and cats — the wording says "your pet" throughout.
const String limpingSymptomId = 'limping';

final DecisionTree limpingTree = {
  'lm_start': const QuestionNode(
    id: 'lm_start',
    questionText:
        'Was your pet hit by a car or did it have a bad fall, or is there an obvious broken bone, deep wound, or heavy bleeding?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'lm_result_emergency_trauma'),
      SymptomOption(label: 'No', nextNodeId: 'lm_paralysis'),
    ],
  ),
  'lm_paralysis': const QuestionNode(
    id: 'lm_paralysis',
    questionText:
        'Is your pet suddenly unable to use their back legs, dragging them, or crying out in pain?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'lm_result_emergency_paralysis'),
      SymptomOption(label: 'No', nextNodeId: 'lm_weight'),
    ],
  ),
  'lm_weight': const QuestionNode(
    id: 'lm_weight',
    questionText: 'Can your pet put any weight on the leg?',
    options: [
      SymptomOption(
        label: "Yes, but they're limping",
        nextNodeId: 'lm_duration',
      ),
      SymptomOption(
        label: 'No, they hold the leg up',
        nextNodeId: 'lm_result_vet_non_weight',
      ),
    ],
  ),
  'lm_duration': const QuestionNode(
    id: 'lm_duration',
    questionText:
        'Has the limp lasted more than 2 days, or is the leg swollen or hot to the touch?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'lm_result_vet_persistent'),
      SymptomOption(label: 'No', nextNodeId: 'lm_result_monitor'),
    ],
  ),
  'lm_result_emergency_trauma': const ResultNode(
    id: 'lm_result_emergency_trauma',
    level: TriageLevel.emergency,
    advice:
        "Serious injuries need emergency care even if your pet seems okay — internal injuries aren't always visible. Keep your pet as still as possible and go to an emergency vet now.",
  ),
  'lm_result_emergency_paralysis': const ResultNode(
    id: 'lm_result_emergency_paralysis',
    level: TriageLevel.emergency,
    advice:
        'Sudden weakness or paralysis in the back legs can be caused by a spinal injury or, in cats, a blood clot. This is an emergency — go to a vet now.',
  ),
  'lm_result_vet_non_weight': const ResultNode(
    id: 'lm_result_vet_non_weight',
    level: TriageLevel.vet,
    advice:
        'Not putting any weight on a leg needs a vet check within 24 hours — it could be a fracture, torn ligament, or painful infection. Keep your pet rested until then.',
  ),
  'lm_result_vet_persistent': const ResultNode(
    id: 'lm_result_vet_persistent',
    level: TriageLevel.vet,
    advice:
        'A limp lasting more than a couple of days, or a swollen or hot leg, should be checked by a vet within 1–2 days.',
  ),
  'lm_result_monitor': const ResultNode(
    id: 'lm_result_monitor',
    level: TriageLevel.monitor,
    advice:
        "A mild limp is often a minor strain. Rest your pet for 24–48 hours, check their paw for thorns or cuts, and see a vet if it doesn't improve. Never give human painkillers — many are toxic to pets.",
  ),
};
