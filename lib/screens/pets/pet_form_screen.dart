import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/breed_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../models/pet.dart';
import '../../providers/pet_provider.dart';
import '../../utils/l10n_helpers.dart';
import '../../utils/validators.dart';
import '../../widgets/common/paw_loader.dart';
import '../../widgets/pets/breed_dropdown.dart';
import '../../widgets/pets/photo_picker_field.dart';

class PetFormScreen extends StatefulWidget {
  final Pet? existingPet;

  const PetFormScreen({super.key, this.existingPet});

  @override
  State<PetFormScreen> createState() => _PetFormScreenState();
}

class _PetFormScreenState extends State<PetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _weightController;
  late final TextEditingController _customBreedController;
  late final TextEditingController _microchipController;
  late final TextEditingController _allergiesController;

  late PetSpecies _species;
  late PetGender _gender;
  late bool _isNeutered;
  String? _breedSelection;
  DateTime? _birthdate;
  Uint8List? _photoBytes;
  String? _validationError;

  /// The form's values when it opened; anything different on Back asks
  /// before discarding.
  late List<Object?> _initialValues;
  bool _hasUnsavedChanges = false;

  bool get _isEditing => widget.existingPet != null;

  List<Object?> _currentValues() => [
    _nameController.text.trim(),
    _weightController.text.trim(),
    _customBreedController.text.trim(),
    _microchipController.text.trim(),
    _allergiesController.text.trim(),
    _species,
    _gender,
    _isNeutered,
    _breedSelection,
    _birthdate,
    _photoBytes,
  ];

  /// Recomputed after every edit so PopScope.canPop stays accurate — an
  /// untouched form still closes with the back button/gesture as usual.
  void _updateUnsavedChanges() {
    final changed = !listEquals(_currentValues(), _initialValues);
    if (changed != _hasUnsavedChanges) {
      setState(() => _hasUnsavedChanges = changed);
    }
  }

  bool get _hasBreedList =>
      _species == PetSpecies.dog || _species == PetSpecies.cat;

  bool get _showCustomBreedField =>
      !_hasBreedList || _breedSelection == kOtherBreedValue;

  @override
  void initState() {
    super.initState();
    final pet = widget.existingPet;
    _nameController = TextEditingController(text: pet?.name ?? '');
    _weightController = TextEditingController(
      text: pet != null ? pet.weightKg.toString() : '',
    );
    _customBreedController = TextEditingController();
    _microchipController = TextEditingController(text: pet?.microchipId ?? '');
    _allergiesController = TextEditingController(text: pet?.allergies ?? '');
    _species = pet?.species ?? PetSpecies.dog;
    _gender = pet?.gender ?? PetGender.male;
    _isNeutered = pet?.isNeutered ?? false;
    _breedSelection = pet?.breed;
    _birthdate = pet?.birthdate;

    // An existing custom breed won't be in the curated list — preselect
    // "Other" and prefill the free-text field with it.
    if (pet != null && pet.breed.isNotEmpty && _hasBreedList) {
      BreedRepository().breedsFor(pet.species).then((breeds) {
        if (!mounted) return;
        if (!breeds.any((b) => b.breed == pet.breed)) {
          setState(() {
            _breedSelection = kOtherBreedValue;
            _customBreedController.text = pet.breed;
          });
          // This fix-up is the app's doing, not the user's edit.
          _initialValues = _currentValues();
          _updateUnsavedChanges();
        }
      });
    } else if (pet != null && !_hasBreedList) {
      _customBreedController.text = pet.breed;
    }

    _initialValues = _currentValues();
    for (final controller in [
      _nameController,
      _weightController,
      _customBreedController,
      _microchipController,
      _allergiesController,
    ]) {
      controller.addListener(_updateUnsavedChanges);
    }
  }

  Future<void> _confirmDiscard() async {
    final l10n = AppLocalizations.of(context)!;
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.discardChangesTitle),
        content: Text(l10n.discardChangesMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.keepEditing),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
              foregroundColor: Theme.of(dialogContext).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.discard),
          ),
        ],
      ),
    );
    if ((discard ?? false) && mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _customBreedController.dispose();
    _microchipController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthdate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthdate ?? DateTime(now.year - 1, now.month, now.day),
      firstDate: DateTime(now.year - 30),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => _birthdate = picked);
      _updateUnsavedChanges();
    }
  }

  Future<void> _submit() async {
    setState(() => _validationError = null);

    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;

    final String breed;
    if (_hasBreedList) {
      if (_breedSelection == null) {
        setState(() => _validationError = l10n.selectBreedError);
        return;
      }
      if (_breedSelection == kOtherBreedValue) {
        breed = _customBreedController.text.trim();
        if (breed.isEmpty) {
          setState(() => _validationError = l10n.enterBreed);
          return;
        }
      } else {
        breed = _breedSelection!;
      }
    } else {
      breed = _customBreedController.text.trim();
    }

    if (_birthdate == null) {
      setState(() => _validationError = l10n.selectBirthdateError);
      return;
    }

    final userId = FirebaseAuth.instance.currentUser!.uid;
    // Curated-list breeds carry their known disorders; custom breeds and
    // non-dog/cat species resolve to an empty list.
    final disorders = await BreedRepository().disordersFor(_species, breed);
    if (!mounted) return;

    final microchip = _microchipController.text.trim();
    final allergies = _allergiesController.text.trim();

    final pet = Pet(
      id: widget.existingPet?.id,
      name: _nameController.text.trim(),
      species: _species,
      breed: breed,
      breedDisorders: disorders,
      birthdate: _birthdate!,
      weightKg: Validators.parseWeight(_weightController.text)!,
      gender: _gender,
      isNeutered: _isNeutered,
      microchipId: microchip.isEmpty ? null : microchip,
      allergies: allergies.isEmpty ? null : allergies,
      photoUrl: widget.existingPet?.photoUrl,
    );

    final petProvider = context.read<PetProvider>();
    final success = await PawLoaderOverlay.during(
      context,
      petProvider.savePet(userId: userId, pet: pet, photoBytes: _photoBytes),
      message: _photoBytes != null ? l10n.uploadingPhoto : l10n.savingPet,
    );

    if (success && mounted) {
      Navigator.of(context).pop();
    } else if (mounted && petProvider.errorCode != null) {
      setState(
        () => _validationError = L10nHelpers.petError(
          AppLocalizations.of(context)!,
          petProvider.errorCode!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLoading = context.watch<PetProvider>().isLoading;
    final dateLabel = _birthdate == null
        ? l10n.selectBirthdate
        : DateFormat.yMMMd().format(_birthdate!);

    // A successful save leaves via Navigator.pop, which PopScope doesn't
    // block; only Back (button, gesture, system) is intercepted.
    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmDiscard();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(_isEditing ? l10n.editPet : l10n.addPet)),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                PhotoPickerField(
                  selectedBytes: _photoBytes,
                  existingPhotoUrl: widget.existingPet?.photoUrl,
                  onPicked: (bytes) {
                    setState(() => _photoBytes = bytes);
                    _updateUnsavedChanges();
                  },
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<PetSpecies>(
                  initialValue: _species,
                  decoration: InputDecoration(labelText: l10n.speciesLabel),
                  items: [
                    for (final species in PetSpecies.values)
                      DropdownMenuItem(
                        value: species,
                        child: Text(L10nHelpers.species(l10n, species)),
                      ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _species = value;
                      _breedSelection = null;
                      _customBreedController.clear();
                    });
                    _updateUnsavedChanges();
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: l10n.petName),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? l10n.nameRequired
                      : null,
                ),
                const SizedBox(height: 16),
                SegmentedButton<PetGender>(
                  segments: [
                    ButtonSegment(
                      value: PetGender.male,
                      icon: const Icon(Icons.male),
                      label: Text(l10n.genderMale),
                    ),
                    ButtonSegment(
                      value: PetGender.female,
                      icon: const Icon(Icons.female),
                      label: Text(l10n.genderFemale),
                    ),
                  ],
                  selected: {_gender},
                  onSelectionChanged: (selection) {
                    setState(() => _gender = selection.first);
                    _updateUnsavedChanges();
                  },
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  value: _isNeutered,
                  onChanged: (value) {
                    setState(() => _isNeutered = value ?? false);
                    _updateUnsavedChanges();
                  },
                  title: Text(l10n.spayedNeutered),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 8),
                if (_hasBreedList) ...[
                  BreedDropdown(
                    species: _species,
                    initialBreed: _breedSelection,
                    onChanged: (value) {
                      setState(() => _breedSelection = value);
                      _updateUnsavedChanges();
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                if (_showCustomBreedField) ...[
                  TextFormField(
                    controller: _customBreedController,
                    decoration: InputDecoration(labelText: l10n.breed),
                  ),
                  const SizedBox(height: 16),
                ],
                OutlinedButton.icon(
                  onPressed: _pickBirthdate,
                  icon: const Icon(Icons.cake_outlined),
                  label: Text(dateLabel),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(labelText: l10n.weightKg),
                  validator: (value) => Validators.weightKg(value, l10n),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _microchipController,
                  decoration: InputDecoration(labelText: l10n.microchipId),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _allergiesController,
                  maxLines: 2,
                  minLines: 1,
                  decoration: InputDecoration(labelText: l10n.allergies),
                ),
                const SizedBox(height: 24),
                if (_validationError != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _validationError!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                FilledButton(
                  onPressed: isLoading ? null : _submit,
                  child: Text(_isEditing ? l10n.saveChanges : l10n.addPet),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
