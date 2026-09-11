import 'decision_tree.dart';

/// Shared by dogs and cats — the wording says "your pet" throughout.
const String toxinSymptomId = 'toxin_ingestion';

final DecisionTree toxinTree = {
  'tx_start': const QuestionNode(
    id: 'tx_start',
    questionText:
        'Is your pet having seizures, trembling, collapsing, or struggling to breathe?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'tx_result_emergency_signs'),
      SymptomOption(label: 'No', nextNodeId: 'tx_what'),
    ],
  ),
  'tx_what': const QuestionNode(
    id: 'tx_what',
    questionText: 'What might your pet have eaten or been exposed to?',
    options: [
      SymptomOption(
        label: 'Human medication',
        nextNodeId: 'tx_result_emergency_known',
      ),
      SymptomOption(
        label: 'Chocolate, xylitol, grapes, raisins, onions, or garlic',
        nextNodeId: 'tx_result_emergency_known',
      ),
      SymptomOption(
        label: 'Lilies or another toxic plant',
        nextNodeId: 'tx_result_emergency_known',
      ),
      SymptomOption(
        label: 'Rat poison, antifreeze, or household chemicals',
        nextNodeId: 'tx_result_emergency_known',
      ),
      SymptomOption(
        label: 'A toy, sock, bone, or other object',
        nextNodeId: 'tx_object',
      ),
      SymptomOption(label: 'Not sure', nextNodeId: 'tx_evidence'),
    ],
  ),
  'tx_object': const QuestionNode(
    id: 'tx_object',
    questionText:
        'Is your pet vomiting repeatedly, unable to keep food down, or does their belly seem painful?',
    options: [
      SymptomOption(
        label: 'Yes',
        nextNodeId: 'tx_result_emergency_obstruction',
      ),
      SymptomOption(label: 'No', nextNodeId: 'tx_result_vet_object'),
    ],
  ),
  'tx_evidence': const QuestionNode(
    id: 'tx_evidence',
    questionText:
        'Did you find chewed packaging, spilled pills, a chewed plant, or an open container nearby?',
    options: [
      SymptomOption(label: 'Yes', nextNodeId: 'tx_result_emergency_known'),
      SymptomOption(label: 'No', nextNodeId: 'tx_result_vet_unsure'),
    ],
  ),
  'tx_result_emergency_signs': const ResultNode(
    id: 'tx_result_emergency_signs',
    level: TriageLevel.emergency,
    advice:
        "These signs need emergency care right now. Go to the nearest emergency vet, and bring the packaging or a sample of what was eaten if it's safe to do so.",
  ),
  'tx_result_emergency_known': const ResultNode(
    id: 'tx_result_emergency_known',
    level: TriageLevel.emergency,
    advice:
        "Many of these are poisonous even in small amounts, and symptoms can take hours to appear. Contact an emergency vet or animal poison hotline now — don't wait for symptoms, and don't make your pet vomit unless a vet tells you to.",
  ),
  'tx_result_emergency_obstruction': const ResultNode(
    id: 'tx_result_emergency_obstruction',
    level: TriageLevel.emergency,
    advice:
        'These can be signs of a blockage in the gut. Go to an emergency vet now.',
  ),
  'tx_result_vet_object': const ResultNode(
    id: 'tx_result_vet_object',
    level: TriageLevel.vet,
    advice:
        'A swallowed object can cause a blockage hours or even days later. Call your vet today for advice, and watch for vomiting, not eating, or a painful belly.',
  ),
  'tx_result_vet_unsure': const ResultNode(
    id: 'tx_result_vet_unsure',
    level: TriageLevel.vet,
    advice:
        "If you suspect poisoning but aren't sure, call your vet or an animal poison hotline now — it's always safer to check. Watch for vomiting, drooling, trembling, or unusual behavior.",
  ),
};
