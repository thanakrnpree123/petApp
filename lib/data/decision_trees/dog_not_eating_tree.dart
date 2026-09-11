import 'decision_tree.dart';

const String dogNotEatingSymptomId = 'not_eating_dog';

final DecisionTree dogNotEatingTree = {
  'dn_start': const QuestionNode(
    id: 'dn_start',
    questionText:
        'Has your pet collapsed, or are their gums pale, white, grey, or blue?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'dn_result_emergency_collapse'),
      SymptomOption(label: 'No', nextNodeId: 'dn_bloat'),
    ],
  ),
  'dn_bloat': const QuestionNode(
    id: 'dn_bloat',
    questionText:
        'Does your dog have a swollen or bloated abdomen, or are they retching without producing vomit?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'dn_result_emergency_bloat'),
      SymptomOption(label: 'No', nextNodeId: 'dn_fluids'),
    ],
  ),
  'dn_fluids': const QuestionNode(
    id: 'dn_fluids',
    questionText: 'Is your dog also refusing water, or vomiting?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'dn_result_vet_today'),
      SymptomOption(label: 'No', nextNodeId: 'dn_duration'),
    ],
  ),
  'dn_duration': const QuestionNode(
    id: 'dn_duration',
    questionText: 'How long has your dog been off their food?',
    options: [
      SymptomOption(label: 'Less than 24 hours', nextNodeId: 'dn_vulnerable'),
      SymptomOption(
        label: 'More than 24 hours',
        nextNodeId: 'dn_result_vet_duration',
      ),
    ],
  ),
  'dn_vulnerable': const QuestionNode(
    id: 'dn_vulnerable',
    questionText:
        'Is your dog a puppy (under 6 months), a senior (over 8 years), or do they have a chronic health condition?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'dn_result_vet_vulnerable'),
      SymptomOption(label: 'No', nextNodeId: 'dn_result_monitor'),
    ],
  ),
  'dn_result_emergency_collapse': const ResultNode(
    id: 'dn_result_emergency_collapse',
    level: TriageLevel.emergency,
    advice:
        'Collapse or pale, white, grey, or blue gums can signal shock, blood loss, or a breathing problem. Go to an emergency vet immediately.',
  ),
  'dn_result_emergency_bloat': const ResultNode(
    id: 'dn_result_emergency_bloat',
    level: TriageLevel.emergency,
    advice:
        'A bloated abdomen with retching can signal GDV (bloat), a life-threatening emergency. Go to an emergency vet immediately.',
  ),
  'dn_result_vet_today': const ResultNode(
    id: 'dn_result_vet_today',
    level: TriageLevel.vet,
    advice:
        'Not eating along with refusing water or vomiting can quickly lead to dehydration. Have your dog seen by a vet today.',
  ),
  'dn_result_vet_duration': const ResultNode(
    id: 'dn_result_vet_duration',
    level: TriageLevel.vet,
    advice:
        "A dog that hasn't eaten for more than a day should be seen by a vet within 24 hours, even without other symptoms.",
  ),
  'dn_result_vet_vulnerable': const ResultNode(
    id: 'dn_result_vet_vulnerable',
    level: TriageLevel.vet,
    advice:
        'Puppies, seniors, and dogs with chronic conditions dehydrate quickly. Book a vet visit within 24 hours.',
  ),
  'dn_result_monitor': const ResultNode(
    id: 'dn_result_monitor',
    level: TriageLevel.monitor,
    advice:
        "Skipping a meal in an otherwise bright, active dog is often caused by heat, stress, or a change in routine. Offer fresh water and their usual food, and see a vet if they still haven't eaten after 24 hours or new symptoms appear.",
  ),
};
