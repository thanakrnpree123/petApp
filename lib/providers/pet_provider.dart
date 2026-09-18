import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../models/pet.dart';
import '../models/health_log.dart';
import '../services/health_log_service.dart';
import '../services/notification_service.dart';
import '../services/pet_service.dart';
import '../services/storage_service.dart';

// Error codes ('timeout' | 'permission-denied' | 'unknown') are localized in
// the UI via L10nHelpers.petError.

class PetProvider extends ChangeNotifier {
  final PetService _petService;
  final StorageService _storageService;
  final NotificationService _notificationService;
  final HealthLogService? _injectedHealthLogs;
  // Lazy: only needed when an edit changes the weight.
  late final HealthLogService _healthLogs =
      _injectedHealthLogs ?? HealthLogService();

  StreamSubscription<List<Pet>>? _petsSubscription;
  String? _watchingUserId;

  List<Pet> pets = [];
  bool isLoading = false;
  String? errorCode;

  PetProvider({
    PetService? petService,
    StorageService? storageService,
    NotificationService? notificationService,
    HealthLogService? healthLogService,
  }) : _petService = petService ?? PetService(),
       _storageService = storageService ?? StorageService(),
       _notificationService = notificationService ?? NotificationService(),
       _injectedHealthLogs = healthLogService;

  void startWatching(String userId) {
    if (_watchingUserId == userId) return;
    _watchingUserId = userId;
    _petsSubscription?.cancel();
    // Never show the previous user's pets while this user's first
    // snapshot is on its way (a shared family device).
    if (pets.isNotEmpty) {
      pets = [];
      notifyListeners();
    }
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
    notifyListeners();
  }

  /// Latest known version of a pet, from the live list.
  Pet? petById(String? petId) {
    for (final pet in pets) {
      if (pet.id == petId) return pet;
    }
    return null;
  }

  /// Saves a pet. A weight changed in the edit form is also recorded as a
  /// weight entry so the chart reflects it (a new pet's first weight is
  /// written by PetService.createPet). Pass [logWeightChange] false when
  /// the caller has already logged the weigh-in itself.
  Future<bool> savePet({
    required String userId,
    required Pet pet,
    Uint8List? photoBytes,
    bool logWeightChange = true,
  }) async {
    isLoading = true;
    errorCode = null;
    notifyListeners();

    String? uploadedUrl;
    var saved = false;
    try {
      final isNew = pet.id == null;
      final petId = pet.id ?? _petService.newPetId(userId);

      String? photoUrl = pet.photoUrl;
      if (photoBytes != null) {
        uploadedUrl = await _storageService.uploadPetPhoto(
          userId: userId,
          petId: petId,
          bytes: photoBytes,
        );
        photoUrl = uploadedUrl;
      }

      final finalPet = pet.copyWith(photoUrl: photoUrl);

      if (isNew) {
        await _petService.createPet(userId, petId, finalPet);
      } else {
        final previousWeight = petById(pet.id)?.weightKg;
        await _petService.updatePet(userId, finalPet);
        if (logWeightChange &&
            previousWeight != null &&
            previousWeight != pet.weightKg) {
          await _healthLogs.addLog(
            userId,
            petId,
            HealthLog(
              type: HealthLogType.weight,
              value: pet.weightKg,
              loggedAt: DateTime.now(),
            ),
          );
        }
      }
      saved = true;

      // The new photo has its own file now; drop the one it replaced.
      final replaced = pet.photoUrl;
      if (uploadedUrl != null && replaced != null && replaced != uploadedUrl) {
        await _deletePhotoQuietly(replaced);
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
      // Uploaded but never saved to the pet: don't leave it orphaned.
      final orphan = uploadedUrl;
      if (!saved && orphan != null) await _deletePhotoQuietly(orphan);
      isLoading = false;
      notifyListeners();
    }
  }

  /// Photo cleanup is best-effort — it must never fail a save that worked.
  Future<void> _deletePhotoQuietly(String url) async {
    try {
      await _storageService.deleteByUrl(url);
    } catch (e) {
      debugPrint('Could not delete old pet photo: $e');
    }
  }

  Future<bool> deletePet(String userId, String petId) async {
    isLoading = true;
    errorCode = null;
    notifyListeners();

    try {
      // Read before deleting — afterwards there's nothing left to list.
      final reminderIds = [
        for (final id in await _petService.vaccinationIds(userId, petId))
          NotificationService.vaccineReminderId(id),
        for (final id in await _petService.careLogIds(userId, petId))
          NotificationService.careReminderId(id),
      ];
      await _petService.deletePet(userId, petId);
      await _cleanUpAfterDelete(userId, petId, reminderIds);
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
    List<int> reminderIds,
  ) async {
    for (final id in reminderIds) {
      try {
        await _notificationService.cancelReminder(id);
      } catch (e) {
        debugPrint('Could not cancel reminder $id: $e');
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
