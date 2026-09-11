import 'decision_tree.dart';

const String dogDiarrheaSymptomId = 'diarrhea_dog';

final DecisionTree dogDiarrheaTree = {
  'dd_start': const QuestionNode(
    id: 'dd_start',
    questionText:
        'Is your dog also vomiting repeatedly, very weak, or collapsing?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'dd_result_emergency_systemic'),
      SymptomOption(label: 'No', nextNodeId: 'dd_blood'),
    ],
  ),
  'dd_blood': const QuestionNode(
    id: 'dd_blood',
    questionText:
        'Is there a lot of blood in the stool (red and jelly-like), or is it black and tarry?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'dd_result_emergency_blood'),
      SymptomOption(label: 'No', nextNodeId: 'dd_toxin'),
    ],
  ),
  'dd_toxin': const QuestionNode(
    id: 'dd_toxin',
    questionText:
        'Could your dog have eaten something toxic (such as medication, chocolate, xylitol, or grapes) or a foreign object?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'dd_result_emergency_toxin'),
      SymptomOption(label: 'No', nextNodeId: 'dd_vulnerable'),
    ],
  ),
  'dd_vulnerable': const QuestionNode(
    id: 'dd_vulnerable',
    questionText:
        'Is your dog a puppy (under 6 months), a senior (over 8 years), unvaccinated, or living with a chronic health condition?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'dd_result_vet_vulnerable'),
      SymptomOption(label: 'No', nextNodeId: 'dd_duration'),
    ],
  ),
  'dd_duration': const QuestionNode(
    id: 'dd_duration',
    questionText: 'How long has the diarrhea lasted?',
    options: [
      SymptomOption(
        label: 'Less than 24 hours',
        nextNodeId: 'dd_result_monitor',
      ),
      SymptomOption(
        label: 'More than 24 hours',
        nextNodeId: 'dd_result_vet_duration',
      ),
    ],
  ),
  'dd_result_emergency_systemic': const ResultNode(
    id: 'dd_result_emergency_systemic',
    level: TriageLevel.emergency,
    advice:
        'Diarrhea with repeated vomiting, weakness, or collapse can quickly cause dangerous dehydration or signal a serious illness. Go to an emergency vet now.',
  ),
  'dd_result_emergency_blood': const ResultNode(
    id: 'dd_result_emergency_blood',
    level: TriageLevel.emergency,
    advice:
        'Large amounts of blood, or black, tarry stool, can mean serious bleeding in the gut. Seek emergency veterinary care now.',
  ),
  'dd_result_emergency_toxin': const ResultNode(
    id: 'dd_result_emergency_toxin',
    level: TriageLevel.emergency,
    advice:
        'Possible toxin or foreign object ingestion is an emergency. Contact an emergency vet or pet poison hotline immediately.',
  ),
  'dd_result_vet_vulnerable': const ResultNode(
    id: 'dd_result_vet_vulnerable',
    level: TriageLevel.vet,
    advice:
        'Puppies, seniors, unvaccinated dogs, and dogs with health conditions dehydrate quickly — and puppies are at risk of parvovirus. Have your dog seen by a vet today.',
  ),
  'dd_result_vet_duration': const ResultNode(
    id: 'dd_result_vet_duration',
    level: TriageLevel.vet,
    advice:
        'Diarrhea lasting more than a day should be checked by a vet within 24 hours. Keep fresh water available, and bring a fresh stool sample if you can.',
  ),
  'dd_result_monitor': const ResultNode(
    id: 'dd_result_monitor',
    level: TriageLevel.monitor,
    advice:
        'Mild diarrhea in a dog that is otherwise bright and eating can usually be watched at home. Keep fresh water available, feed small bland meals, and see a vet if it lasts more than 24 hours or new symptoms appear.',
  ),
};
