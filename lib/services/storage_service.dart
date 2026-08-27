import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage;

  StorageService({FirebaseStorage? storage})
    : _storage = storage ?? FirebaseStorage.instance {
    // The SDK defaults to retrying failed uploads for up to 10 MINUTES,
    // which reads as an app hang on flaky networks. Bound it so failures
    // surface to the UI quickly instead.
    _storage.setMaxUploadRetryTime(const Duration(seconds: 20));
    _storage.setMaxOperationRetryTime(const Duration(seconds: 10));
  }

  /// Uploads pet photo bytes. Uses putData rather than putFile so the same
  /// call works on web, where `dart:io` File is unavailable.
  Future<String> uploadPetPhoto({
    required String userId,
    required String petId,
    required Uint8List bytes,
  }) async {
    final ref = _storage.ref().child('users/$userId/pets/$petId/photo.jpg');
    await ref
        .putData(bytes, SettableMetadata(contentType: 'image/jpeg'))
        .timeout(const Duration(seconds: 45));
    return ref.getDownloadURL().timeout(const Duration(seconds: 15));
  }
}
