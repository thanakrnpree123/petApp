import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/pet.dart';

class BreedEntry {
  final String breed;
  final List<String> disorders;

  const BreedEntry({required this.breed, required this.disorders});
}

class BreedRepository {
  static final BreedRepository _instance = BreedRepository._internal();
  factory BreedRepository() => _instance;
  BreedRepository._internal();

  List<BreedEntry>? _dogBreeds;
  List<BreedEntry>? _catBreeds;

  Future<void> _ensureLoaded() async {
    _dogBreeds ??= await _loadAsset('assets/data/dog_breeds.json');
    _catBreeds ??= await _loadAsset('assets/data/cat_breeds.json');
  }

  Future<List<BreedEntry>> _loadAsset(String path) async {
    final raw = await rootBundle.loadString(path);
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map(
          (e) => BreedEntry(
            breed: e['breed'] as String,
            disorders: List<String>.from(e['disorders'] as List),
          ),
        )
        .toList();
  }

  Future<List<BreedEntry>> breedsFor(PetSpecies species) async {
    await _ensureLoaded();
    return switch (species) {
      PetSpecies.dog => _dogBreeds!,
      PetSpecies.cat => _catBreeds!,
      // Only dogs and cats have curated breed lists; other species use
      // free-text breed entry in the form.
      _ => const [],
    };
  }

  Future<List<String>> disordersFor(PetSpecies species, String breed) async {
    final breeds = await breedsFor(species);
    final match = breeds.where((b) => b.breed == breed);
    return match.isEmpty ? [] : match.first.disorders;
  }
}
