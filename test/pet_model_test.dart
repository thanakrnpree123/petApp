import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pawhealth/models/care_log.dart';
import 'package:pawhealth/models/pet.dart';

Map<String, dynamic> _baseDoc() => {
  'name': 'Bella',
  'species': 'dog',
  'breed': 'Labrador Retriever',
  'breed_disorders': ['hip_dysplasia'],
  'birthdate': Timestamp.fromDate(DateTime(2022, 3, 14)),
  'weight_kg': 28.5,
  'photo_url': null,
};

void main() {
  group('Pet gender/neutered defaults', () {
    test('documents without the new fields default to male / not neutered', () {
      final pet = Pet.fromFirestore('p1', _baseDoc());
      expect(pet.gender, PetGender.male);
      expect(pet.isNeutered, false);
      expect(pet.tracksHeatCycle, false);
    });

    test('reads stored gender and neutered values', () {
      final pet = Pet.fromFirestore('p1', {
        ..._baseDoc(),
        'gender': 'female',
        'is_neutered': true,
      });
      expect(pet.gender, PetGender.female);
      expect(pet.isNeutered, true);
      expect(pet.tracksHeatCycle, false, reason: 'spayed female');
    });

    test('intact female dog tracks heat cycle', () {
      final pet = Pet.fromFirestore('p1', {
        ..._baseDoc(),
        'gender': 'female',
        'is_neutered': false,
      });
      expect(pet.tracksHeatCycle, true);
    });

    test('intact female rabbit does NOT track heat cycle (dogs/cats only)', () {
      final pet = Pet.fromFirestore('p1', {
        ..._baseDoc(),
        'species': 'rabbit',
        'gender': 'female',
        'is_neutered': false,
      });
      expect(pet.tracksHeatCycle, false);
    });

    test('unknown species value falls back to exotic', () {
      final pet = Pet.fromFirestore('p1', {..._baseDoc(), 'species': 'ferret'});
      expect(pet.species, PetSpecies.exotic);
    });

    test('microchip and allergies round-trip and default to null', () {
      final bare = Pet.fromFirestore('p1', _baseDoc());
      expect(bare.microchipId, isNull);
      expect(bare.allergies, isNull);

      final pet = Pet.fromFirestore('p1', {
        ..._baseDoc(),
        'microchip_id': '981000012345678',
        'allergies': 'Chicken, penicillin',
      });
      final map = pet.toFirestore();
      expect(map['microchip_id'], '981000012345678');
      expect(map['allergies'], 'Chicken, penicillin');
    });
  });

  group('Pet.ageParts', () {
    Pet petBorn(DateTime birthdate) => Pet(
      name: 'x',
      species: PetSpecies.dog,
      breed: 'b',
      breedDisorders: const [],
      birthdate: birthdate,
      weightKg: 1,
    );

    test('years and months', () {
      final age = petBorn(
        DateTime(2024, 3, 10),
      ).ageParts(DateTime(2026, 6, 15));
      expect(age.years, 2);
      expect(age.months, 3);
    });

    test('under a year reports months only', () {
      final age = petBorn(
        DateTime(2026, 1, 20),
      ).ageParts(DateTime(2026, 6, 15));
      expect(age.years, 0);
      expect(age.months, 4);
    });

    test('day-of-month boundary rolls the month down', () {
      final age = petBorn(
        DateTime(2025, 6, 20),
      ).ageParts(DateTime(2026, 6, 15));
      expect(age.years, 0);
      expect(age.months, 11);
    });

    test('toFirestore round-trips the new fields', () {
      final pet = Pet.fromFirestore('p1', {
        ..._baseDoc(),
        'gender': 'female',
        'is_neutered': true,
      });
      final map = pet.toFirestore();
      expect(map['gender'], 'female');
      expect(map['is_neutered'], true);
    });
  });

  group('CareCategory', () {
    test('round-trips canonical values', () {
      for (final category in CareCategory.values) {
        expect(CareCategory.fromValue(category.value), category);
      }
    });

    test('unknown stored value falls back instead of crashing', () {
      expect(CareCategory.fromValue('future_category'), CareCategory.other);
    });
  });
}
