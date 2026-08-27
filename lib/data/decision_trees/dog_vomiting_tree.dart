import 'decision_tree.dart';

const String dogVomitingSymptomId = 'vomiting_dog';

const String symptomCheckerDisclaimer =
    'This tool provides general guidance only and is not a substitute for '
    'professional veterinary diagnosis. When in doubt, contact your vet.';

final DecisionTree dogVomitingTree = {
  'start': const QuestionNode(
    id: 'start',
    questionText: 'How many times has your dog vomited in the last 24 hours?',
    options: [
      SymptomOption(label: '1 time', nextNodeId: 'blood_check_mild'),
      SymptomOption(label: '2-3 times', nextNodeId: 'blood_check_moderate'),
      SymptomOption(
        label: '4 or more times',
        nextNodeId: 'result_emergency_frequent',
      ),
      SymptomOption(
        label: 'No symptoms / General checkup',
        nextNodeId: 'result_healthy',
      ),
    ],
  ),
  'blood_check_mild': const QuestionNode(
    id: 'blood_check_mild',
    questionText:
        'Is there any blood in the vomit (red streaks or coffee-ground appearance)?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'result_emergency_blood'),
      SymptomOption(label: 'No', nextNodeId: 'lethargy_check_mild'),
    ],
  ),
  'lethargy_check_mild': const QuestionNode(
    id: 'lethargy_check_mild',
    questionText: 'Is your dog acting lethargic, weak, or unlike themselves?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'result_vet_lethargy'),
      SymptomOption(label: 'No', nextNodeId: 'toxin_check'),
    ],
  ),
  'toxin_check': const QuestionNode(
    id: 'toxin_check',
    questionText:
        'Could your dog have eaten something toxic, a foreign object, human medication, or spoiled food?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'result_emergency_toxin'),
      SymptomOption(label: 'No', nextNodeId: 'result_monitor_mild'),
    ],
  ),
  'blood_check_moderate': const QuestionNode(
    id: 'blood_check_moderate',
    questionText:
        'Is there any blood in the vomit (red streaks or coffee-ground appearance)?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'result_emergency_blood'),
      SymptomOption(label: 'No', nextNodeId: 'bloat_check'),
    ],
  ),
  'bloat_check': const QuestionNode(
    id: 'bloat_check',
    questionText:
        'Does your dog have a swollen or bloated abdomen, or are they retching without producing vomit?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'result_emergency_bloat'),
      SymptomOption(label: 'No', nextNodeId: 'age_check'),
    ],
  ),
  'age_check': const QuestionNode(
    id: 'age_check',
    questionText:
        'Is your dog a puppy (under 6 months), a senior (over 8 years), or do they have a chronic health condition?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'result_vet_vulnerable'),
      SymptomOption(label: 'No', nextNodeId: 'lethargy_check_moderate'),
    ],
  ),
  'lethargy_check_moderate': const QuestionNode(
    id: 'lethargy_check_moderate',
    questionText: 'Is your dog acting lethargic, weak, or refusing water?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'result_vet_lethargy'),
      SymptomOption(label: 'No', nextNodeId: 'result_vet_moderate'),
    ],
  ),
  'result_emergency_frequent': const ResultNode(
    id: 'result_emergency_frequent',
    level: TriageLevel.emergency,
    advice:
        'Vomiting 4+ times in 24 hours risks serious dehydration. Contact an emergency vet immediately.',
  ),
  'result_emergency_blood': const ResultNode(
    id: 'result_emergency_blood',
    level: TriageLevel.emergency,
    advice:
        'Blood in vomit can indicate internal bleeding or a serious GI issue. Seek emergency veterinary care now.',
  ),
  'result_emergency_toxin': const ResultNode(
    id: 'result_emergency_toxin',
    level: TriageLevel.emergency,
    advice:
        'Possible toxin or foreign object ingestion is an emergency. Contact an emergency vet or pet poison hotline immediately.',
  ),
  'result_emergency_bloat': const ResultNode(
    id: 'result_emergency_bloat',
    level: TriageLevel.emergency,
    advice:
        'A bloated abdomen with retching can signal GDV (bloat), a life-threatening emergency. Go to an emergency vet immediately.',
  ),
  'result_vet_lethargy': const ResultNode(
    id: 'result_vet_lethargy',
    level: TriageLevel.vet,
    advice:
        'Lethargy alongside vomiting warrants a same-day vet visit. Withhold food, offer small sips of water.',
  ),
  'result_vet_vulnerable': const ResultNode(
    id: 'result_vet_vulnerable',
    level: TriageLevel.vet,
    advice:
        'Puppies, seniors, and dogs with chronic conditions dehydrate quickly. Book a vet visit within 24 hours.',
  ),
  'result_vet_moderate': const ResultNode(
    id: 'result_vet_moderate',
    level: TriageLevel.vet,
    advice:
        'Repeated vomiting without other red flags still warrants a vet check within 24 hours. Withhold food for 12 hours, offer small amounts of water.',
  ),
  'result_monitor_mild': const ResultNode(
    id: 'result_monitor_mild',
    level: TriageLevel.monitor,
    advice:
        'A single vomiting episode with no other symptoms can often be monitored at home. Withhold food for a few hours, ensure fresh water, and watch for recurrence.',
  ),
  'result_healthy': const ResultNode(
    id: 'result_healthy',
    level: TriageLevel.monitor,
    advice:
        'Your pet seems healthy! Keep up the good work — continue regular checkups and preventive care.',
  ),
};
