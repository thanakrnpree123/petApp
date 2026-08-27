import 'package:cloud_firestore/cloud_firestore.dart';

enum PetSpecies { dog, cat, rabbit, bird, exotic }

extension PetSpeciesX on PetSpecies {
  String get value => name;

  static PetSpecies fromValue(String value) {
    return PetSpecies.values.firstWhere(
      (s) => s.name == value,
      orElse: () => PetSpecies.exotic,
    );
  }
}

enum PetGender { male, female }

class Pet {
  final String? id;
  final String name;
  final PetSpecies species;
  final String breed;
  final List<String> breedDisorders;
  final DateTime birthdate;
  final double weightKg;
  final PetGender gender;
  final bool isNeutered;
  final String? microchipId;
  final String? allergies;
  final String? photoUrl;

  Pet({
    this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.breedDisorders,
    required this.birthdate,
    required this.weightKg,
    this.gender = PetGender.male,
    this.isNeutered = false,
    this.microchipId,
    this.allergies,
    this.photoUrl,
  });

  /// Heat-cycle tracking only applies to intact female dogs and cats.
  bool get tracksHeatCycle =>
      (species == PetSpecies.dog || species == PetSpecies.cat) &&
      gender == PetGender.female &&
      !isNeutered;

  /// Current age split into whole years and remaining months.
  /// UI formats it via L10nHelpers.petAge.
  ({int years, int months}) ageParts([DateTime? asOf]) {
    final now = asOf ?? DateTime.now();
    var years = now.year - birthdate.year;
    var months = now.month - birthdate.month;
    if (now.day < birthdate.day) months -= 1;
    if (months < 0) {
      years -= 1;
      months += 12;
    }
    if (years < 0) return (years: 0, months: 0);
    return (years: years, months: months);
  }

  factory Pet.fromFirestore(String id, Map<String, dynamic> data) {
    return Pet(
      id: id,
      name: data['name'] as String,
      species: PetSpeciesX.fromValue(data['species'] as String),
      breed: data['breed'] as String,
      breedDisorders: List<String>.from(data['breed_disorders'] as List),
      birthdate: (data['birthdate'] as Timestamp).toDate(),
      weightKg: (data['weight_kg'] as num).toDouble(),
      // Documents created before these fields existed default to male /
      // not neutered, per product decision.
      gender: data['gender'] == 'female' ? PetGender.female : PetGender.male,
      isNeutered: data['is_neutered'] as bool? ?? false,
      microchipId: data['microchip_id'] as String?,
      allergies: data['allergies'] as String?,
      photoUrl: data['photo_url'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'species': species.value,
      'breed': breed,
      'breed_disorders': breedDisorders,
      'birthdate': Timestamp.fromDate(birthdate),
      'weight_kg': weightKg,
      'gender': gender.name,
      'is_neutered': isNeutered,
      'microchip_id': microchipId,
      'allergies': allergies,
      'photo_url': photoUrl,
      'updated_at': FieldValue.serverTimestamp(),
    };
  }

  Pet copyWith({
    String? name,
    PetSpecies? species,
    String? breed,
    List<String>? breedDisorders,
    DateTime? birthdate,
    double? weightKg,
    PetGender? gender,
    bool? isNeutered,
    String? microchipId,
    String? allergies,
    String? photoUrl,
  }) {
    return Pet(
      id: id,
      name: name ?? this.name,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      breedDisorders: breedDisorders ?? this.breedDisorders,
      birthdate: birthdate ?? this.birthdate,
      weightKg: weightKg ?? this.weightKg,
      gender: gender ?? this.gender,
      isNeutered: isNeutered ?? this.isNeutered,
      microchipId: microchipId ?? this.microchipId,
      allergies: allergies ?? this.allergies,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
