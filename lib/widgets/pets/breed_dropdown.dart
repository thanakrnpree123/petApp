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

  /// Shown under the field, like any other form error.
  final String? errorText;

  const BreedDropdown({
    super.key,
    required this.species,
    required this.onChanged,
    this.initialBreed,
    this.errorText,
  });

  @override
  State<BreedDropdown> createState() => _BreedDropdownState();
}

class _BreedDropdownState extends State<BreedDropdown> {
  static const _menuHeight = 320.0;

  late Future<List<BreedEntry>> _breedsFuture;
  final _menuController = MenuController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _breedsFuture = BreedRepository().breedsFor(widget.species);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) _makeRoomBelow();
  }

  /// Menus open below their field when there's room and flip above when
  /// there isn't — and flipped above, the list covered the field's own
  /// label. So when the field is focused near the bottom of the screen,
  /// scroll it up first. Scrolling closes an open menu, so it's reopened
  /// once the scroll settles, now with room below.
  Future<void> _makeRoomBelow() async {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || Scrollable.maybeOf(context) == null) {
      return;
    }
    final fieldBottom = box.localToGlobal(Offset(0, box.size.height)).dy;
    final visibleBottom =
        MediaQuery.sizeOf(context).height -
        MediaQuery.viewInsetsOf(context).bottom;
    if (visibleBottom - fieldBottom >= _menuHeight + 16) return;

    await Scrollable.ensureVisible(
      context,
      alignment: 0.05,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
    if (mounted && _focusNode.hasFocus && !_menuController.isOpen) {
      _menuController.open();
    }
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
          focusNode: _focusNode,
          menuController: _menuController,
          initialSelection: initial,
          label: Text(AppLocalizations.of(context)!.breed),
          errorText: widget.errorText,
          expandedInsets: EdgeInsets.zero,
          // ~150 breeds: keep the list a scrollable panel rather than a
          // sheet that covers the whole form.
          menuHeight: _menuHeight,
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
