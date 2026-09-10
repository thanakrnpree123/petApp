import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../models/pet.dart';
import '../services/notification_service.dart';
import '../services/pet_service.dart';
import '../services/storage_service.dart';

// Error codes ('timeout' | 'permission-denied' | 'unknown') are localized in
// the UI via L10nHelpers.petError.

class PetProvider extends ChangeNotifier {
  final PetService _petService;
  final StorageService _storageService;
  final NotificationService _notificationService;

  StreamSubscription<List<Pet>>? _petsSubscription;
  String? _watchingUserId;

  List<Pet> pets = [];
  bool isLoading = false;
  String? errorCode;

  PetProvider({
    PetService? petService,
    StorageService? storageService,
    NotificationService? notificationService,
  }) : _petService = petService ?? PetService(),
       _storageService = storageService ?? StorageService(),
       _notificationService = notificationService ?? NotificationService();

  void startWatching(String userId) {
    if (_watchingUserId == userId) return;
    _watchingUserId = userId;
    _petsSubscription?.cancel();
    _petsSubscription = _petService
        .watchPets(userId)
        .listen(
          (updated) {
            pets = updated;
            notifyListeners();
          },
          // The listener outlives the user when they're signed out or their
          // account is deleted; the rules then deny the read. Clear rather
          // than surfacing an uncaught stream error.
          onError: (Object _) {
            pets = [];
            notifyListeners();
          },
        );
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

  Future<bool> deletePet(String userId, String petId) async {
    isLoading = true;
    errorCode = null;
    notifyListeners();

    try {
      // Read before deleting — afterwards there's nothing left to list.
      final vaccinationIds = await _petService.vaccinationIds(userId, petId);
      await _petService.deletePet(userId, petId);
      await _cleanUpAfterDelete(userId, petId, vaccinationIds);
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

  /// Removes what lives outside Firestore once the pet's data is gone:
  /// scheduled reminders (a "vaccine due" alert for a pet that has died is
  /// exactly the wrong moment to reach an owner) and the photo in Storage.
  /// Best-effort — the pet is already deleted, so a failure here must not
  /// report the delete as failed.
  Future<void> _cleanUpAfterDelete(
    String userId,
    String petId,
    List<String> vaccinationIds,
  ) async {
    for (final id in vaccinationIds) {
      try {
        await _notificationService.cancelReminder(
          NotificationService.vaccineReminderId(id),
        );
      } catch (e) {
        debugPrint('Could not cancel reminder for vaccination $id: $e');
      }
    }
    try {
      await _storageService.deleteFolder('users/$userId/pets/$petId');
    } catch (e) {
      debugPrint('Could not delete photos for pet $petId: $e');
    }
  }

  @override
  void dispose() {
    _petsSubscription?.cancel();
    super.dispose();
  }
}
