import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/health_log.dart';
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

  Future<List<Pet>> fetchPets(String userId) async {
    final snapshot = await _petsRef(userId).get();
    return [
      for (final doc in snapshot.docs) Pet.fromFirestore(doc.id, doc.data()),
    ];
  }

  String newPetId(String userId) => _petsRef(userId).doc().id;

  /// Creates the pet and records the weight entered in the form as its
  /// first weight entry — in one batch, so a pet never exists without it
  /// and a retry can't create a duplicate pet.
  Future<void> createPet(String userId, String petId, Pet pet) {
    final petDoc = _petsRef(userId).doc(petId);
    final batch = _firestore.batch()
      ..set(petDoc, {
        ...pet.toFirestore(),
        'created_at': FieldValue.serverTimestamp(),
      })
      ..set(
        petDoc.collection('health_logs').doc(),
        HealthLog(
          type: HealthLogType.weight,
          value: pet.weightKg,
          loggedAt: DateTime.now(),
        ).toFirestore(),
      );
    return batch.commit();
  }

  Future<void> updatePet(String userId, Pet pet) {
    return _petsRef(userId).doc(pet.id).update(pet.toFirestore());
  }

  /// Every subcollection stored under a pet document. Firestore doesn't
  /// cascade-delete, and the client SDK can't list subcollections, so any
  /// new per-pet collection MUST be added here or deleting a pet (or an
  /// account) will silently orphan it.
  static const petSubcollections = [
    'health_logs',
    'vaccinations',
    'care_logs',
    'symptom_checks',
  ];

  /// A Firestore write batch holds at most 500 operations.
  static const _maxBatchSize = 500;

  Future<List<String>> vaccinationIds(String userId, String petId) async {
    final snapshot = await _petsRef(
      userId,
    ).doc(petId).collection('vaccinations').get();
    return [for (final doc in snapshot.docs) doc.id];
  }

  Future<List<String>> careLogIds(String userId, String petId) async {
    final snapshot = await _petsRef(
      userId,
    ).doc(petId).collection('care_logs').get();
    return [for (final doc in snapshot.docs) doc.id];
  }

  Future<List<String>> petIds(String userId) async {
    final snapshot = await _petsRef(userId).get();
    return [for (final doc in snapshot.docs) doc.id];
  }

  /// Clears each subcollection first, then the pet doc — deleting just the
  /// pet doc would orphan its health_logs, vaccinations, care_logs and
  /// symptom_checks.
  Future<void> deletePet(String userId, String petId) async {
    final petDoc = _petsRef(userId).doc(petId);
    for (final name in petSubcollections) {
      await _deleteCollection(petDoc.collection(name));
    }
    await petDoc.delete();
  }

  /// Deletes a collection in pages so it works past the 500-op batch limit.
  Future<void> _deleteCollection(
    CollectionReference<Map<String, dynamic>> collection,
  ) async {
    while (true) {
      final page = await collection.limit(_maxBatchSize).get();
      if (page.docs.isEmpty) return;
      final batch = _firestore.batch();
      for (final doc in page.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      if (page.docs.length < _maxBatchSize) return;
    }
  }
}
