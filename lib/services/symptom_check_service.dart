import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/symptom_check.dart';

class SymptomCheckService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _checksRef(
    String userId,
    String petId,
  ) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('pets')
        .doc(petId)
        .collection('symptom_checks');
  }

  Future<void> saveCheck(String userId, String petId, SymptomCheck check) {
    return _checksRef(userId, petId).add(check.toFirestore());
  }

  Future<SymptomCheck?> getLatestCheck(String userId, String petId) async {
    final snapshot = await _checksRef(
      userId,
      petId,
    ).orderBy('checked_at', descending: true).limit(1).get();
    if (snapshot.docs.isEmpty) return null;
    final doc = snapshot.docs.first;
    return SymptomCheck.fromFirestore(doc.id, doc.data());
  }

  static const freeMonthlyLimit = 5;

  Future<bool> hasReachedFreeLimit(String userId) async {
    final now = DateTime.now();
    final startOfMonth = Timestamp.fromDate(DateTime(now.year, now.month, 1));

    final petsSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('pets')
        .get();

    var count = 0;
    for (final petDoc in petsSnapshot.docs) {
      final aggregate = await _checksRef(
        userId,
        petDoc.id,
      ).where('checked_at', isGreaterThanOrEqualTo: startOfMonth).count().get();
      count += aggregate.count ?? 0;
      if (count >= freeMonthlyLimit) return true;
    }
    return count >= freeMonthlyLimit;
  }
}
