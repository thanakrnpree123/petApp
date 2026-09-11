import 'breathing_tree.dart';
import 'cat_not_eating_tree.dart';
import 'cat_urinary_tree.dart';
import 'cat_vomiting_tree.dart';
import 'decision_tree.dart';
import 'dog_diarrhea_tree.dart';
import 'dog_not_eating_tree.dart';
import 'dog_vomiting_tree.dart';
import 'limping_tree.dart';
import 'toxin_tree.dart';

/// One symptom a user can pick in the checker, and the tree that triages it.
///
/// Pure Dart like the rest of this folder: species are matched by name
/// (`PetSpecies.name`) so the catalog doesn't depend on the Firestore model.
class SymptomDefinition {
  /// Stable id stored on each saved check (`symptom` in Firestore).
  final String id;

  /// Canonical English name — used where no BuildContext is available
  /// (PDF report) and as the fallback for untranslated ids.
  final String name;
  final Set<String> species;
  final DecisionTree tree;
  final String startNodeId;

  const SymptomDefinition({
    required this.id,
    required this.name,
    required this.species,
    required this.tree,
    required this.startNodeId,
  });
}

/// Every symptom in picker order: most common first.
final List<SymptomDefinition> symptomCatalog = [
  SymptomDefinition(
    id: dogVomitingSymptomId,
    name: 'Vomiting',
    species: const {'dog'},
    tree: dogVomitingTree,
    startNodeId: 'start',
  ),
  SymptomDefinition(
    id: catVomitingSymptomId,
    name: 'Vomiting',
    species: const {'cat'},
    tree: catVomitingTree,
    startNodeId: 'cv_start',
  ),
  SymptomDefinition(
    id: dogDiarrheaSymptomId,
    name: 'Diarrhea',
    species: const {'dog'},
    tree: dogDiarrheaTree,
    startNodeId: 'dd_start',
  ),
  SymptomDefinition(
    id: dogNotEatingSymptomId,
    name: 'Not eating or low energy',
    species: const {'dog'},
    tree: dogNotEatingTree,
    startNodeId: 'dn_start',
  ),
  SymptomDefinition(
    id: catNotEatingSymptomId,
    name: 'Not eating or low energy',
    species: const {'cat'},
    tree: catNotEatingTree,
    startNodeId: 'cn_start',
  ),
  SymptomDefinition(
    id: catUrinarySymptomId,
    name: 'Peeing problems',
    species: const {'cat'},
    tree: catUrinaryTree,
    startNodeId: 'cu_start',
  ),
  SymptomDefinition(
    id: toxinSymptomId,
    name: 'Ate something harmful',
    species: const {'dog', 'cat'},
    tree: toxinTree,
    startNodeId: 'tx_start',
  ),
  SymptomDefinition(
    id: breathingSymptomId,
    name: 'Breathing problems',
    species: const {'dog', 'cat'},
    tree: breathingTree,
    startNodeId: 'br_start',
  ),
  SymptomDefinition(
    id: limpingSymptomId,
    name: 'Limping or injury',
    species: const {'dog', 'cat'},
    tree: limpingTree,
    startNodeId: 'lm_start',
  ),
];

List<SymptomDefinition> symptomsForSpecies(String speciesName) => [
  for (final symptom in symptomCatalog)
    if (symptom.species.contains(speciesName)) symptom,
];

SymptomDefinition? symptomById(String id) {
  for (final symptom in symptomCatalog) {
    if (symptom.id == id) return symptom;
  }
  return null;
}
