import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../models/pet.dart';
import '../services/pet_service.dart';
import '../services/storage_service.dart';

// Error codes ('timeout' | 'permission-denied' | 'unknown') are localized in
// the UI via L10nHelpers.petError.

class PetProvider extends ChangeNotifier {
  final PetService _petService;
  final StorageService _storageService;

  StreamSubscription<List<Pet>>? _petsSubscription;
  String? _watchingUserId;

  List<Pet> pets = [];
  bool isLoading = false;
  String? errorCode;

  PetProvider({PetService? petService, StorageService? storageService})
    : _petService = petService ?? PetService(),
      _storageService = storageService ?? StorageService();

  void startWatching(String userId) {
    if (_watchingUserId == userId) return;
    _watchingUserId = userId;
    _petsSubscription?.cancel();
    _petsSubscription = _petService.watchPets(userId).listen((updated) {
      pets = updated;
      notifyListeners();
    });
  }

  void stopWatching() {
    _petsSubscription?.cancel();
    _petsSubscription = null;
    _watchingUserId = null;
    pets = [];
  }

  Future<bool> savePet({
    required String userId,
    required Pet pet,
    Uint8List? photoBytes,
  }) async {
    isLoading = true;
    errorCode = null;
    notifyListeners();

    try {
      final isNew = pet.id == null;
      final petId = pet.id ?? _petService.newPetId(userId);

      String? photoUrl = pet.photoUrl;
      if (photoBytes != null) {
        photoUrl = await _storageService.uploadPetPhoto(
          userId: userId,
          petId: petId,
          bytes: photoBytes,
        );
      }

      final finalPet = pet.copyWith(photoUrl: photoUrl);

      if (isNew) {
        await _petService.createPet(userId, petId, finalPet);
      } else {
        await _petService.updatePet(userId, finalPet);
      }

      return true;
    } on TimeoutException {
      errorCode = 'timeout';
      return false;
    } on FirebaseException catch (e) {
      errorCode = e.code == 'permission-denied' || e.code == 'unauthorized'
          ? 'permission-denied'
          : 'unknown';
      return false;
    } catch (_) {
      errorCode = 'unknown';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deletePet(String userId, String petId) {
    return _petService.deletePet(userId, petId);
  }

  @override
  void dispose() {
    _petsSubscription?.cancel();
    super.dispose();
  }
}
