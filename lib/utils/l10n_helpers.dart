import '../data/decision_trees/breathing_tree.dart';
import '../data/decision_trees/cat_not_eating_tree.dart';
import '../data/decision_trees/cat_urinary_tree.dart';
import '../data/decision_trees/cat_vomiting_tree.dart';
import '../data/decision_trees/decision_tree.dart';
import '../data/decision_trees/dog_diarrhea_tree.dart';
import '../data/decision_trees/dog_not_eating_tree.dart';
import '../data/decision_trees/dog_vomiting_tree.dart';
import '../data/decision_trees/limping_tree.dart';
import '../data/decision_trees/symptom_catalog.dart';
import '../data/decision_trees/toxin_tree.dart';
import '../l10n/app_localizations.dart';
import '../models/article.dart';
import '../models/care_log.dart';
import '../models/symptom_check.dart';
import '../models/pet.dart';

/// Bridges canonical-English data (decision-tree nodes, provider error
/// codes, Firestore-stored strings) to localized presentation strings.
///
/// The tree and Firestore keep English as the stable canonical form; only
/// what the user sees is translated. Unknown ids fall back to the canonical
/// English text so a new tree node can never crash an outdated mapping.
abstract final class L10nHelpers {
  // Node ids are unique across every tree in the symptom catalog (each
  // tree prefixes its own), so one switch per kind covers all trees.
  // Nodes that ask/advise the same thing share one ARB key.
  static String question(AppLocalizations l10n, QuestionNode node) {
    return switch (node.id) {
      // Dog — vomiting
      'start' => l10n.qVomitFrequency,
      'blood_check_mild' || 'blood_check_moderate' => l10n.qBloodInVomit,
      'lethargy_check_mild' => l10n.qLethargyMild,
      'toxin_check' => l10n.qToxinIngestion,
      'bloat_check' => l10n.qBloatedAbdomen,
      'age_check' => l10n.qAgeVulnerable,
      'lethargy_check_moderate' => l10n.qLethargyModerate,
      // Shared across trees
      'dn_start' || 'cn_start' || 'br_start' => l10n.qCollapse,
      'cn_urinary' || 'cu_start' => l10n.qUrinaryStraining,
      // Dog — diarrhea
      'dd_start' => l10n.qDdSystemic,
      'dd_blood' => l10n.qDdBlood,
      'dd_toxin' => l10n.qDdToxin,
      'dd_vulnerable' => l10n.qDdVulnerable,
      'dd_duration' => l10n.qDiarrheaDuration,
      // Dog — not eating
      'dn_bloat' => l10n.qBloatedAbdomen,
      'dn_fluids' => l10n.qDnFluids,
      'dn_duration' => l10n.qDnDuration,
      'dn_vulnerable' => l10n.qAgeVulnerable,
      // Cat — vomiting
      'cv_start' => l10n.qCatVomitFrequency,
      'cv_blood_single' || 'cv_blood_repeat' => l10n.qBloodInVomit,
      'cv_foreign_single' || 'cv_foreign_repeat' => l10n.qCatForeign,
      'cv_lethargy_single' || 'cv_lethargy_repeat' => l10n.qCatLethargy,
      // Cat — not eating
      'cn_duration' => l10n.qCnDuration,
      'cn_signs' => l10n.qCnSigns,
      // Cat — urinary
      'cu_blood' => l10n.qCuBlood,
      'cu_frequency' => l10n.qCuFrequency,
      'cu_thirst' => l10n.qCuThirst,
      // Ate something harmful
      'tx_start' => l10n.qTxSigns,
      'tx_what' => l10n.qTxWhat,
      'tx_object' => l10n.qTxObject,
      'tx_evidence' => l10n.qTxEvidence,
      // Breathing
      'br_heat' => l10n.qBrHeat,
      'br_effort' => l10n.qBrEffort,
      'br_cough' => l10n.qBrCough,
      'br_unwell' => l10n.qBrUnwell,
      // Limping
      'lm_start' => l10n.qLmTrauma,
      'lm_paralysis' => l10n.qLmParalysis,
      'lm_weight' => l10n.qLmWeight,
      'lm_duration' => l10n.qLmDuration,
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
      'Less than 24 hours' => l10n.optLess24h,
      'More than 24 hours' => l10n.optMore24h,
      'Human medication' => l10n.optHumanMedication,
      'Chocolate, xylitol, grapes, raisins, onions, or garlic' =>
        l10n.optToxicFoods,
      'Lilies or another toxic plant' => l10n.optToxicPlant,
      'Rat poison, antifreeze, or household chemicals' => l10n.optChemicals,
      'A toy, sock, bone, or other object' => l10n.optObject,
      'Not sure' => l10n.optNotSure,
      "Yes, but they're limping" => l10n.optLimpingYes,
      'No, they hold the leg up' => l10n.optLimpingNo,
      _ => option.label,
    };
  }

  static String advice(AppLocalizations l10n, ResultNode node) {
    return switch (node.id) {
      // Dog — vomiting
      'result_emergency_frequent' => l10n.advEmergencyFrequent,
      'result_emergency_blood' => l10n.advEmergencyBlood,
      'result_emergency_toxin' => l10n.advEmergencyToxin,
      'result_emergency_bloat' => l10n.advEmergencyBloat,
      'result_vet_lethargy' => l10n.advVetLethargy,
      'result_vet_vulnerable' => l10n.advVetVulnerable,
      'result_vet_moderate' => l10n.advVetModerate,
      'result_monitor_mild' => l10n.advMonitorMild,
      // Shared across trees
      'dn_result_emergency_collapse' ||
      'cn_result_emergency_collapse' ||
      'br_result_emergency_collapse' => l10n.advEmergencyCollapse,
      'cn_result_emergency_urinary' ||
      'cu_result_emergency_blocked' => l10n.advEmergencyUrinary,
      // Dog — diarrhea
      'dd_result_emergency_systemic' => l10n.advDdSystemic,
      'dd_result_emergency_blood' => l10n.advDdBlood,
      'dd_result_emergency_toxin' => l10n.advEmergencyToxin,
      'dd_result_vet_vulnerable' => l10n.advDdVulnerable,
      'dd_result_vet_duration' => l10n.advDdDuration,
      'dd_result_monitor' => l10n.advDdMonitor,
      // Dog — not eating
      'dn_result_emergency_bloat' => l10n.advEmergencyBloat,
      'dn_result_vet_today' => l10n.advDnVetToday,
      'dn_result_vet_duration' => l10n.advDnDuration,
      'dn_result_vet_vulnerable' => l10n.advVetVulnerable,
      'dn_result_monitor' => l10n.advDnMonitor,
      // Cat — vomiting
      'cv_result_emergency_frequent' => l10n.advEmergencyFrequent,
      'cv_result_emergency_blood' => l10n.advEmergencyBlood,
      'cv_result_emergency_foreign' => l10n.advCvForeign,
      'cv_result_vet_lethargy' => l10n.advCvLethargy,
      'cv_result_vet_repeat' => l10n.advCvRepeat,
      'cv_result_monitor' => l10n.advCvMonitor,
      // Cat — not eating
      'cn_result_vet_fasting' => l10n.advCnFasting,
      'cn_result_vet_signs' => l10n.advCnSigns,
      'cn_result_monitor' => l10n.advCnMonitor,
      // Cat — urinary
      'cu_result_vet_pain' => l10n.advCuPain,
      'cu_result_vet_thirst' => l10n.advCuThirst,
      'cu_result_vet_behavior' => l10n.advCuBehavior,
      'cu_result_monitor' => l10n.advCuMonitor,
      // Ate something harmful
      'tx_result_emergency_signs' => l10n.advTxSigns,
      'tx_result_emergency_known' => l10n.advTxKnown,
      'tx_result_emergency_obstruction' => l10n.advTxObstruction,
      'tx_result_vet_object' => l10n.advTxObject,
      'tx_result_vet_unsure' => l10n.advTxUnsure,
      // Breathing
      'br_result_emergency_heat' => l10n.advBrHeat,
      'br_result_emergency_breathing' => l10n.advBrBreathing,
      'br_result_vet' => l10n.advBrVet,
      'br_result_monitor_cough' => l10n.advBrMonitorCough,
      'br_result_monitor' => l10n.advBrMonitor,
      // Limping
      'lm_result_emergency_trauma' => l10n.advLmTrauma,
      'lm_result_emergency_paralysis' => l10n.advLmParalysis,
      'lm_result_vet_non_weight' => l10n.advLmNonWeight,
      'lm_result_vet_persistent' => l10n.advLmPersistent,
      'lm_result_monitor' => l10n.advLmMonitor,
      _ => node.advice,
    };
  }

  /// Localized advice for a saved check. Firestore keeps only the canonical
  /// English advice, so the matching result node is looked up in the
  /// symptom's tree; unknown or legacy advice falls back to the English.
  static String savedAdvice(AppLocalizations l10n, SymptomCheck check) {
    final tree = symptomById(check.symptomId)?.tree;
    if (tree != null) {
      for (final node in tree.values) {
        if (node is ResultNode && node.advice == check.advice) {
          return advice(l10n, node);
        }
      }
    }
    return _retiredAdvice[check.advice]?.call(l10n) ?? check.advice;
  }

  /// A saved answer's question and answer in the app language. Firestore
  /// keeps the canonical English text, so both are looked up in the
  /// symptom's tree; anything no longer in it stays as saved.
  static ({String question, String answer}) savedAnswer(
    AppLocalizations l10n,
    SymptomCheck check,
    SymptomAnswer saved,
  ) {
    final node = symptomById(check.symptomId)?.tree[saved.questionId];
    if (node is! QuestionNode) {
      return (question: saved.questionText, answer: saved.answer);
    }
    final matching = node.options.where((o) => o.label == saved.answer);
    return (
      question: question(l10n, node),
      answer: matching.isEmpty ? saved.answer : option(l10n, matching.first),
    );
  }

  /// Advice of results since removed from the trees, keyed by the English
  /// text stored with older saved checks, so their history still shows in
  /// the user's language.
  static final _retiredAdvice = <String, String Function(AppLocalizations)>{
    // Dog vomiting's "No symptoms / General checkup" answer: a symptom
    // check isn't a wellness check, and "seems healthy" was false
    // reassurance.
    'Your pet seems healthy! Keep up the good work — continue regular '
        'checkups and preventive care.': (l10n) =>
        l10n.advHealthy,
  };

  /// Category ids used by the seeded articles (tool/seed_articles); any
  /// other id falls back to a title-cased label.
  static String articleCategory(AppLocalizations l10n, Article article) {
    return switch (article.category) {
      'first_aid' => l10n.articleCatFirstAid,
      'safety' => l10n.articleCatSafety,
      'preventive_care' => l10n.articleCatPreventiveCare,
      'nutrition' => l10n.articleCatNutrition,
      'symptoms' => l10n.articleCatSymptoms,
      _ => article.categoryLabel,
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
      dogVomitingSymptomId || catVomitingSymptomId => l10n.symptomVomiting,
      dogDiarrheaSymptomId => l10n.symptomDiarrhea,
      dogNotEatingSymptomId || catNotEatingSymptomId => l10n.symptomNotEating,
      catUrinarySymptomId => l10n.symptomUrinary,
      toxinSymptomId => l10n.symptomToxin,
      breathingSymptomId => l10n.symptomBreathing,
      limpingSymptomId => l10n.symptomLimping,
      _ => symptomById(symptomId)?.name ?? symptomId.replaceAll('_', ' '),
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
