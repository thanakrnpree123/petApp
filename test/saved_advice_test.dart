import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/data/decision_trees/decision_tree.dart';
import 'package:pawhealth/data/decision_trees/dog_vomiting_tree.dart';
import 'package:pawhealth/l10n/app_localizations_th.dart';
import 'package:pawhealth/models/symptom_check.dart';
import 'package:pawhealth/utils/l10n_helpers.dart';

SymptomCheck _check(String advice) => SymptomCheck(
  symptomId: dogVomitingSymptomId,
  answers: const [],
  triageLevel: TriageLevel.emergency,
  advice: advice,
  checkedAt: DateTime(2026, 9, 11),
);

void main() {
  final th = AppLocalizationsTh();

  test('saved English advice is shown in the app language', () {
    final node = dogVomitingTree['result_emergency_frequent'] as ResultNode;
    expect(
      L10nHelpers.savedAdvice(th, _check(node.advice)),
      th.advEmergencyFrequent,
    );
  });

  test('advice no longer in the catalog falls back to what was saved', () {
    expect(
      L10nHelpers.savedAdvice(th, _check('Old wording from 2025.')),
      'Old wording from 2025.',
    );
  });

  test('checks saved from a retired result are still translated', () {
    // "No symptoms / General checkup" was removed from the vomiting tree;
    // history saved before then must not revert to English.
    const retired =
        'Your pet seems healthy! Keep up the good work — continue regular '
        'checkups and preventive care.';
    expect(L10nHelpers.savedAdvice(th, _check(retired)), th.advHealthy);
  });
}
