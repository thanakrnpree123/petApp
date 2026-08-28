import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/pet.dart';

class PetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _petsRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('pets');
  }

  Stream<List<Pet>> watchPets(String userId) {
    return _petsRef(userId)
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Pet.fromFirestore(doc.id, doc.data()))
              .toList(),
        );
  }

  String newPetId(String userId) => _petsRef(userId).doc().id;

  Future<void> createPet(String userId, String petId, Pet pet) {
    return _petsRef(userId).doc(petId).set({
      ...pet.toFirestore(),
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updatePet(String userId, Pet pet) {
    return _petsRef(userId).doc(pet.id).update(pet.toFirestore());
  }

  /// Firestore doesn't cascade-delete subcollections, so deleting just the
  /// pet doc would silently orphan its health_logs, vaccinations, care_logs
  /// and symptom_checks. Clear each subcollection first, then the pet doc.
  Future<void> deletePet(String userId, String petId) async {
    final petDoc = _petsRef(userId).doc(petId);
    const subcollections = [
      'health_logs',
      'vaccinations',
      'care_logs',
      'symptom_checks',
    ];

    for (final name in subcollections) {
      final snapshot = await petDoc.collection(name).get();
      if (snapshot.docs.isEmpty) continue;
      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }

    await petDoc.delete();
  }
}
