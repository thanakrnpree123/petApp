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

  Future<void> deletePet(String userId, String petId) {
    return _petsRef(userId).doc(petId).delete();
  }
}
