import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/decision_trees/breathing_tree.dart';
import '../../data/decision_trees/cat_urinary_tree.dart';
import '../../data/decision_trees/decision_tree.dart';
import '../../data/decision_trees/dog_diarrhea_tree.dart';
import '../../data/decision_trees/limping_tree.dart';
import '../../data/decision_trees/symptom_catalog.dart';
import '../../data/decision_trees/toxin_tree.dart';
import '../../models/pet.dart';
import '../../models/symptom_check.dart';
import '../../l10n/app_localizations.dart';
import '../../services/symptom_check_service.dart';
import '../../services/symptom_checker.dart';
import '../../theme/app_theme.dart';
import '../../utils/l10n_helpers.dart';
import '../../widgets/symptom_checker/question_card.dart';
import '../../widgets/symptom_checker/triage_result_card.dart';

class SymptomCheckerScreen extends StatefulWidget {
  final Pet pet;

  const SymptomCheckerScreen({super.key, required this.pet});

  @override
  State<SymptomCheckerScreen> createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends State<SymptomCheckerScreen> {
  final _service = SymptomCheckService();
  late final List<SymptomDefinition> _symptoms = symptomsForSpecies(
    widget.pet.species.name,
  );

  /// Null while the symptom picker is showing.
  SymptomDefinition? _symptom;
  SymptomChecker? _checker;

  /// Built the moment the checker reaches a result.
  SymptomCheck? _check;
  bool _isSaved = false;
  bool _isSaving = false;

  void _pickSymptom(SymptomDefinition symptom) {
    setState(() {
      _symptom = symptom;
      _checker = SymptomChecker(symptom.tree, startNodeId: symptom.startNodeId);
    });
  }

  /// Back from a question: rewinds one answer, or returns to the picker
  /// from the first question.
  void _back(SymptomChecker checker) {
    setState(() {
      if (checker.path.isEmpty) {
        _symptom = null;
        _checker = null;
      } else {
        checker.goBack();
      }
    });
  }

  void _answer(SymptomChecker checker, SymptomOption option) {
    setState(() => checker.answer(option));
    if (!checker.isComplete) return;

    // Record the check the moment a result is shown — not when the user
    // taps Share. The free-tier limit counts saved checks, so saving only
    // on share let free users run unlimited checks by never sharing.
    _check = SymptomCheck(
      symptomId: _symptom!.id,
      answers: checker.path,
      triageLevel: checker.result.level,
      advice: checker.result.advice,
      checkedAt: DateTime.now(),
    );
    _save();
  }

  Future<void> _save() async {
    final check = _check;
    if (check == null || _isSaved || _isSaving) return;
    _isSaving = true;

    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      await _service.saveCheck(userId, widget.pet.id!, check);
      if (mounted) setState(() => _isSaved = true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.checkSaveFailed),
          ),
        );
      }
    } finally {
      _isSaving = false;
    }
  }

  Future<void> _share() async {
    final check = _check;
    if (check == null) return;
    // Retry a failed save, but never make sharing wait on it: offline,
    // a Firestore write doesn't complete until the device reconnects —
    // and an owner at the vet's door at 2 AM still needs to share.
    _save();

    await SharePlus.instance.share(
      ShareParams(
        text: _buildShareSummary(AppLocalizations.of(context)!, check),
      ),
    );
  }

  String _buildShareSummary(AppLocalizations l10n, SymptomCheck check) {
    final checker = _checker!;
    final buffer = StringBuffer()
      ..writeln(l10n.shareSummaryTitle(widget.pet.name))
      ..writeln(
        l10n.shareSymptom(L10nHelpers.symptomName(l10n, check.symptomId)),
      )
      ..writeln(
        l10n.shareTriageLevel(L10nHelpers.triageLabel(l10n, check.triageLevel)),
      )
      ..writeln(l10n.shareAdvice(L10nHelpers.advice(l10n, checker.result)))
      ..writeln()
      ..writeln(l10n.shareAnswersHeader);
    for (final answer in check.answers) {
      buffer.writeln('- ${answer.questionText} ${answer.answer}');
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final checker = _checker;

    final Widget body;
    if (_symptoms.isEmpty) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(l10n.noChecksForSpecies, textAlign: TextAlign.center),
        ),
      );
    } else if (checker == null) {
      body = _buildPicker();
    } else if (checker.isComplete) {
      body = _buildResult(checker);
    } else {
      body = _buildQuestion(checker);
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.symptomCheckerTitle(widget.pet.name))),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: body,
          ),
        ),
      ),
    );
  }

  Widget _buildPicker() {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final danger = context.statusColors.danger;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        // Shown before any question: an owner in a true emergency
        // shouldn't have to click through a quiz to be told to go.
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: danger.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: danger.withValues(alpha: 0.4)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.warning_amber_rounded, color: danger),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.emergencyNotice,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          l10n.symptomPickerTitle(widget.pet.name),
          style: textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text(
          l10n.symptomPickerHint,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        for (final symptom in _symptoms) ...[
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              leading: CircleAvatar(
                backgroundColor: colorScheme.primaryContainer,
                child: Icon(
                  _iconFor(symptom.id),
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              title: Text(L10nHelpers.symptomName(l10n, symptom.id)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _pickSymptom(symptom),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  static IconData _iconFor(String symptomId) => switch (symptomId) {
    dogDiarrheaSymptomId => Icons.water_drop_outlined,
    catUrinarySymptomId => Icons.opacity,
    toxinSymptomId => Icons.dangerous_outlined,
    breathingSymptomId => Icons.air,
    // A bandage — the previous icon read as a wheelchair.
    limpingSymptomId => Icons.healing_outlined,
    _ when symptomId.startsWith('not_eating') => Icons.no_meals_outlined,
    _ => Icons.sick_outlined,
  };

  Widget _buildQuestion(SymptomChecker checker) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => _back(checker),
            icon: const Icon(Icons.arrow_back),
            label: Text(AppLocalizations.of(context)!.back),
          ),
        ),
        const SizedBox(height: 8),
        QuestionCard(
          node: checker.currentNode as QuestionNode,
          onAnswer: (option) => _answer(checker, option),
        ),
      ],
    );
  }

  Widget _buildResult(SymptomChecker checker) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      children: [
        TriageResultCard(
          level: checker.result.level,
          advice: L10nHelpers.advice(l10n, checker.result),
          disclaimer: l10n.medicalDisclaimer,
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: _share,
          icon: const Icon(Icons.share),
          label: Text(l10n.shareWithVet),
        ),
        if (_isSaved) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                size: 18,
                color: context.statusColors.success,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  l10n.checkSavedToHistory(widget.pet.name),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
