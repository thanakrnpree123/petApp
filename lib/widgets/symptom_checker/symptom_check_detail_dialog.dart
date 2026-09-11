import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/symptom_check.dart';
import '../../utils/app_dates.dart';
import '../../utils/l10n_helpers.dart';
import 'triage_result_card.dart';

/// Read-only view of a symptom check saved to the pet's health history.
class SymptomCheckDetailDialog extends StatelessWidget {
  final SymptomCheck check;

  const SymptomCheckDetailDialog({super.key, required this.check});

  static Future<void> show(BuildContext context, SymptomCheck check) {
    return showDialog<void>(
      context: context,
      builder: (_) => SymptomCheckDetailDialog(check: check),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(L10nHelpers.symptomName(l10n, check.symptomId)),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppDates.medium(context).format(check.checkedAt),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              TriageResultCard(
                level: check.triageLevel,
                advice: L10nHelpers.savedAdvice(l10n, check),
                disclaimer: l10n.medicalDisclaimer,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.close),
        ),
      ],
    );
  }
}
