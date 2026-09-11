import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/models/pet.dart';
import 'package:pawhealth/providers/pet_provider.dart';
import 'package:pawhealth/services/notification_service.dart';
import 'package:pawhealth/services/pet_service.dart';
import 'package:pawhealth/services/storage_service.dart';

const _oldUrl = 'https://storage.example/pets/p1/photo_1.jpg?token=a';
const _newUrl = 'https://storage.example/pets/p1/photo_2.jpg?token=b';

class _FakePetService implements PetService {
  bool failSave = false;
  Pet? saved;

  @override
  String newPetId(String userId) => 'p-new';

  @override
  Future<void> updatePet(String userId, Pet pet) async {
    if (failSave) {
      throw FirebaseException(plugin: 'cloud_firestore', code: 'unavailable');
    }
    saved = pet;
  }

  @override
  Future<void> createPet(String userId, String petId, Pet pet) async =>
      saved = pet;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeStorage implements StorageService {
  final uploads = <String>[];
  final deleted = <String>[];

  @override
  Future<String> uploadPetPhoto({
    required String userId,
    required String petId,
    required Uint8List bytes,
  }) async {
    uploads.add(petId);
    return _newUrl;
  }

  @override
  Future<void> deleteByUrl(String downloadUrl) async =>
      deleted.add(downloadUrl);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Unused implements NotificationService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Pet _pet({String? photoUrl}) => Pet(
  id: 'p1',
  name: 'Mochi',
  species: PetSpecies.cat,
  breed: 'Siamese',
  breedDisorders: const [],
  birthdate: DateTime(2023),
  weightKg: 4,
  photoUrl: photoUrl,
);

void main() {
  late _FakePetService pets;
  late _FakeStorage storage;
  late PetProvider provider;

  setUp(() {
    pets = _FakePetService();
    storage = _FakeStorage();
    provider = PetProvider(
      petService: pets,
      storageService: storage,
      notificationService: _Unused(),
    );
  });

  final newPhoto = Uint8List.fromList([1, 2, 3]);

  test('a replaced photo gets a new URL and the old file is removed', () async {
    final ok = await provider.savePet(
      userId: 'u1',
      pet: _pet(photoUrl: _oldUrl),
      photoBytes: newPhoto,
    );

    expect(ok, isTrue);
    // A different URL is what makes the pet list (and every image cache)
    // show the new photo.
    expect(pets.saved!.photoUrl, _newUrl);
    expect(storage.deleted, [_oldUrl]);
  });

  test('a failed save keeps the old photo and removes the orphan', () async {
    pets.failSave = true;

    final ok = await provider.savePet(
      userId: 'u1',
      pet: _pet(photoUrl: _oldUrl),
      photoBytes: newPhoto,
    );

    expect(ok, isFalse);
    expect(storage.deleted, [_newUrl], reason: 'old photo must survive');
  });

  test('editing other fields leaves the photo alone', () async {
    await provider.savePet(
      userId: 'u1',
      pet: _pet(photoUrl: _oldUrl),
    );

    expect(storage.uploads, isEmpty);
    expect(storage.deleted, isEmpty);
    expect(pets.saved!.photoUrl, _oldUrl);
  });

  test('the first photo for a pet deletes nothing', () async {
    await provider.savePet(userId: 'u1', pet: _pet(), photoBytes: newPhoto);

    expect(pets.saved!.photoUrl, _newUrl);
    expect(storage.deleted, isEmpty);
  });
}
