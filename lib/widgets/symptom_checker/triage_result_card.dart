import 'package:flutter/material.dart';

import '../../data/decision_trees/decision_tree.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/l10n_helpers.dart';

class TriageResultCard extends StatelessWidget {
  final TriageLevel level;
  final String advice;
  final String disclaimer;

  const TriageResultCard({
    super.key,
    required this.level,
    required this.advice,
    required this.disclaimer,
  });

  Color _colorFor(StatusColors status) => switch (level) {
    TriageLevel.monitor => status.success,
    TriageLevel.vet => status.warning,
    TriageLevel.emergency => status.danger,
  };

  IconData get _icon => switch (level) {
    TriageLevel.monitor => Icons.home_outlined,
    TriageLevel.vet => Icons.medical_services_outlined,
    TriageLevel.emergency => Icons.warning_amber_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(context.statusColors);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(_icon, color: color, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      L10nHelpers.triageLabel(
                        AppLocalizations.of(context)!,
                        level,
                      ),
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: color),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(advice, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          disclaimer,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
