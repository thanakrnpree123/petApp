import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/decision_trees/decision_tree.dart';
import '../../data/decision_trees/dog_vomiting_tree.dart';
import '../../models/pet.dart';
import '../../models/symptom_check.dart';
import '../../l10n/app_localizations.dart';
import '../../services/symptom_check_service.dart';
import '../../services/symptom_checker.dart';
import '../../utils/l10n_helpers.dart';
import '../../widgets/common/paw_loader.dart';
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
  SymptomChecker? _checker;
  bool _isSaving = false;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    if (widget.pet.species == PetSpecies.dog) {
      _checker = SymptomChecker(dogVomitingTree);
    }
  }

  Future<void> _save() async {
    final checker = _checker;
    if (checker == null || !checker.isComplete) return;

    setState(() => _isSaving = true);

    final check = SymptomCheck(
      symptomId: dogVomitingSymptomId,
      answers: checker.path,
      triageLevel: checker.result.level,
      advice: checker.result.advice,
      checkedAt: DateTime.now(),
    );

    final userId = FirebaseAuth.instance.currentUser!.uid;
    final l10n = AppLocalizations.of(context)!;
    await PawLoaderOverlay.during(
      context,
      _service.saveCheck(userId, widget.pet.id!, check),
      message: l10n.savingCheck,
    );

    if (!mounted) return;
    setState(() {
      _isSaving = false;
      _isSaved = true;
    });

    await SharePlus.instance.share(
      ShareParams(text: _buildShareSummary(l10n, check)),
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
    final checker = _checker;

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.symptomCheckerTitle(widget.pet.name))),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: checker == null
            ? Center(child: Text(l10n.noChecksForSpecies))
            : checker.isComplete
            ? _buildResult(checker)
            : _buildQuestion(checker),
      ),
    );
  }

  Widget _buildQuestion(SymptomChecker checker) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (checker.path.isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => setState(checker.goBack),
              icon: const Icon(Icons.arrow_back),
              label: Text(AppLocalizations.of(context)!.back),
            ),
          ),
        const SizedBox(height: 8),
        QuestionCard(
          node: checker.currentNode as QuestionNode,
          onAnswer: (option) => setState(() => checker.answer(option)),
        ),
      ],
    );
  }

  Widget _buildResult(SymptomChecker checker) {
    return ListView(
      children: [
        TriageResultCard(
          level: checker.result.level,
          advice: L10nHelpers.advice(
            AppLocalizations.of(context)!,
            checker.result,
          ),
          disclaimer: AppLocalizations.of(context)!.medicalDisclaimer,
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: _isSaving ? null : _save,
          icon: const Icon(Icons.share),
          label: Text(
            _isSaved
                ? AppLocalizations.of(context)!.savedShareAgain
                : AppLocalizations.of(context)!.saveShareWithVet,
          ),
        ),
      ],
    );
  }
}
