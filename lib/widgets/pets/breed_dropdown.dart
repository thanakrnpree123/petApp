import 'package:flutter/material.dart';

import '../../data/breed_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../models/pet.dart';
import '../common/paw_loader.dart';

/// Sentinel emitted when the user picks "Other (Please specify)" — the form
/// then shows a free-text breed field. Never stored in Firestore.
const String kOtherBreedValue = '__other__';

class BreedDropdown extends StatefulWidget {
  final PetSpecies species;
  final String? initialBreed;
  final ValueChanged<String> onChanged;

  const BreedDropdown({
    super.key,
    required this.species,
    required this.onChanged,
    this.initialBreed,
  });

  @override
  State<BreedDropdown> createState() => _BreedDropdownState();
}

class _BreedDropdownState extends State<BreedDropdown> {
  late Future<List<BreedEntry>> _breedsFuture;

  @override
  void initState() {
    super.initState();
    _breedsFuture = BreedRepository().breedsFor(widget.species);
  }

  @override
  void didUpdateWidget(covariant BreedDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.species != widget.species) {
      _breedsFuture = BreedRepository().breedsFor(widget.species);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BreedEntry>>(
      future: _breedsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: PawLoader(size: 40),
          );
        }

        final breeds = snapshot.data!;
        final knownInitial = breeds.any((b) => b.breed == widget.initialBreed);
        final initial = knownInitial
            ? widget.initialBreed
            : (widget.initialBreed == kOtherBreedValue
                  ? kOtherBreedValue
                  : null);

        return DropdownMenu<String>(
          key: ValueKey(widget.species),
          initialSelection: initial,
          label: Text(AppLocalizations.of(context)!.breed),
          expandedInsets: EdgeInsets.zero,
          enableFilter: true,
          enableSearch: true,
          requestFocusOnTap: true,
          dropdownMenuEntries: [
            for (final b in breeds)
              DropdownMenuEntry(value: b.breed, label: b.breed),
            DropdownMenuEntry(
              value: kOtherBreedValue,
              label: AppLocalizations.of(context)!.breedOther,
            ),
          ],
          onSelected: (value) {
            if (value != null) widget.onChanged(value);
          },
        );
      },
    );
  }
}
