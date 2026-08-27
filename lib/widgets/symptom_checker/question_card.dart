import 'package:flutter/material.dart';

import '../../data/decision_trees/decision_tree.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/l10n_helpers.dart';

class QuestionCard extends StatelessWidget {
  final QuestionNode node;
  final ValueChanged<SymptomOption> onAnswer;

  const QuestionCard({super.key, required this.node, required this.onAnswer});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          L10nHelpers.question(l10n, node),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),
        for (final option in node.options) ...[
          FilledButton.tonal(
            onPressed: () => onAnswer(option),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(L10nHelpers.option(l10n, option)),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
