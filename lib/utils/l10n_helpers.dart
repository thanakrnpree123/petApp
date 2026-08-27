import '../data/decision_trees/decision_tree.dart';
import '../data/decision_trees/dog_vomiting_tree.dart';
import '../l10n/app_localizations.dart';
import '../models/care_log.dart';
import '../models/pet.dart';

/// Bridges canonical-English data (decision-tree nodes, provider error
/// codes, Firestore-stored strings) to localized presentation strings.
///
/// The tree and Firestore keep English as the stable canonical form; only
/// what the user sees is translated. Unknown ids fall back to the canonical
/// English text so a new tree node can never crash an outdated mapping.
abstract final class L10nHelpers {
  static String question(AppLocalizations l10n, QuestionNode node) {
    return switch (node.id) {
      'start' => l10n.qVomitFrequency,
      'blood_check_mild' || 'blood_check_moderate' => l10n.qBloodInVomit,
      'lethargy_check_mild' => l10n.qLethargyMild,
      'toxin_check' => l10n.qToxinIngestion,
      'bloat_check' => l10n.qBloatedAbdomen,
      'age_check' => l10n.qAgeVulnerable,
      'lethargy_check_moderate' => l10n.qLethargyModerate,
      _ => node.questionText,
    };
  }

  static String option(AppLocalizations l10n, SymptomOption option) {
    return switch (option.label) {
      '1 time' => l10n.opt1Time,
      '2-3 times' => l10n.opt2to3Times,
      '4 or more times' => l10n.opt4Plus,
      'Yes' => l10n.optYes,
      'No' => l10n.optNo,
      'No symptoms / General checkup' => l10n.optNoSymptoms,
      _ => option.label,
    };
  }

  static String advice(AppLocalizations l10n, ResultNode node) {
    return switch (node.id) {
      'result_emergency_frequent' => l10n.advEmergencyFrequent,
      'result_emergency_blood' => l10n.advEmergencyBlood,
      'result_emergency_toxin' => l10n.advEmergencyToxin,
      'result_emergency_bloat' => l10n.advEmergencyBloat,
      'result_vet_lethargy' => l10n.advVetLethargy,
      'result_vet_vulnerable' => l10n.advVetVulnerable,
      'result_vet_moderate' => l10n.advVetModerate,
      'result_monitor_mild' => l10n.advMonitorMild,
      'result_healthy' => l10n.advHealthy,
      _ => node.advice,
    };
  }

  static String triageLabel(AppLocalizations l10n, TriageLevel level) {
    return switch (level) {
      TriageLevel.monitor => l10n.triageMonitor,
      TriageLevel.vet => l10n.triageVet,
      TriageLevel.emergency => l10n.triageEmergency,
    };
  }

  static String symptomName(AppLocalizations l10n, String symptomId) {
    return switch (symptomId) {
      dogVomitingSymptomId => l10n.symptomVomiting,
      _ => symptomId.replaceAll('_', ' '),
    };
  }

  static String authError(AppLocalizations l10n, String code) {
    return switch (code) {
      'invalid-email' => l10n.errInvalidEmail,
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' => l10n.errIncorrectCredentials,
      'email-already-in-use' => l10n.errEmailInUse,
      'weak-password' => l10n.errWeakPassword,
      'permission-denied' => l10n.errPermissionDenied,
      _ => l10n.errGeneric,
    };
  }

  static String petError(AppLocalizations l10n, String code) {
    return switch (code) {
      'timeout' => l10n.errSaveTimeout,
      'permission-denied' => l10n.errRulesPermission,
      _ => l10n.errCouldNotSavePet,
    };
  }

  static String species(AppLocalizations l10n, PetSpecies species) {
    return switch (species) {
      PetSpecies.dog => l10n.speciesDog,
      PetSpecies.cat => l10n.speciesCat,
      PetSpecies.rabbit => l10n.speciesRabbit,
      PetSpecies.bird => l10n.speciesBird,
      PetSpecies.exotic => l10n.speciesExotic,
    };
  }

  static String petAge(AppLocalizations l10n, Pet pet, [DateTime? asOf]) {
    final age = pet.ageParts(asOf);
    return age.years > 0
        ? l10n.ageYearsMonths(age.years, age.months)
        : l10n.ageMonths(age.months);
  }

  static String careCategory(AppLocalizations l10n, CareCategory category) {
    return switch (category) {
      CareCategory.parasiteControl => l10n.careParasiteControl,
      CareCategory.heatCycle => l10n.careHeatCycle,
      CareCategory.medicalSurgery => l10n.careMedicalSurgery,
      CareCategory.grooming => l10n.careGrooming,
      CareCategory.other => l10n.filterOther,
    };
  }

  static String subscriptionError(AppLocalizations l10n, String code) {
    return switch (code) {
      'load-failed' => l10n.errSubscriptionLoad,
      'purchase-failed' => l10n.errPurchaseFailed,
      'restore-failed' => l10n.errRestoreFailed,
      _ => l10n.errGeneric,
    };
  }
}
