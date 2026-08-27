import 'package:flutter/material.dart';

import '../../data/decision_trees/decision_tree.dart';
import '../../l10n/app_localizations.dart';
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

  Color get _color => switch (level) {
    TriageLevel.monitor => Colors.green,
    TriageLevel.vet => Colors.orange,
    TriageLevel.emergency => Colors.red,
  };

  IconData get _icon => switch (level) {
    TriageLevel.monitor => Icons.home_outlined,
    TriageLevel.vet => Icons.medical_services_outlined,
    TriageLevel.emergency => Icons.warning_amber_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _color, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(_icon, color: _color),
                  const SizedBox(width: 8),
                  Text(
                    L10nHelpers.triageLabel(
                      AppLocalizations.of(context)!,
                      level,
                    ),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: _color,
                      fontWeight: FontWeight.bold,
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
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}
