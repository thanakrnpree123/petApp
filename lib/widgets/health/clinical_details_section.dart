import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Collapsible optional fields recording who administered something and
/// what exactly was given — the vet's name and licence number, plus the
/// vaccine lot number or the medicine and dose, as a paper vaccination
/// book records them.
///
/// Collapsed by default so the everyday path (name, date, done) stays
/// short; expanded from the start when the record already has details,
/// so editing never hides data behind a tap.
class ClinicalDetailsSection extends StatelessWidget {
  final TextEditingController veterinarianController;
  final TextEditingController licenseController;

  /// The product field, which differs by record type: a vaccine's lot
  /// number, or a care record's medicine and dose.
  final TextEditingController productController;
  final String productLabel;
  final bool initiallyExpanded;

  const ClinicalDetailsSection({
    super.key,
    required this.veterinarianController,
    required this.licenseController,
    required this.productController,
    required this.productLabel,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ExpansionTile(
      title: Text(
        l10n.clinicalDetails,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      initiallyExpanded: initiallyExpanded,
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: 8),
      expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
      // The dialog draws its own separators; ExpansionTile's would double up.
      shape: const Border(),
      collapsedShape: const Border(),
      children: [
        TextFormField(
          controller: productController,
          decoration: InputDecoration(labelText: productLabel),
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: veterinarianController,
          decoration: InputDecoration(labelText: l10n.veterinarianName),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: licenseController,
          decoration: InputDecoration(labelText: l10n.vetLicenseNo),
        ),
      ],
    );
  }
}
