import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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

  /// Newest first — shown in the pet's health timeline.
  Stream<List<SymptomCheck>> watchChecks(String userId, String petId) {
    return _checksRef(userId, petId)
        .orderBy('checked_at', descending: true)
        .snapshots()
        .map(
          (snapshot) => [
            for (final doc in snapshot.docs)
              SymptomCheck.fromFirestore(doc.id, doc.data()),
          ],
        );
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

  /// How long the free-limit lookup may take before the check is allowed.
  static const limitCheckTimeout = Duration(seconds: 4);

  /// Whether a free user should be sent to the paywall instead of the
  /// checker. Fails OPEN: if the count can't be fetched — offline (count
  /// queries need the server), slow, or erroring — the check is allowed.
  /// Blocking an owner at 2 AM costs far more than one missed upsell, and
  /// the completed check is still saved and counted once back online.
  Future<bool> shouldBlockFreeCheck(String userId) =>
      failOpen(() => hasReachedFreeLimit(userId));

  @visibleForTesting
  static Future<bool> failOpen(
    Future<bool> Function() limitReached, {
    Duration timeout = limitCheckTimeout,
  }) async {
    try {
      return await limitReached().timeout(timeout);
    } catch (_) {
      return false;
    }
  }

  Future<bool> hasReachedFreeLimit(String userId) async {
    final now = DateTime.now();
    final startOfMonth = Timestamp.fromDate(DateTime(now.year, now.month, 1));

    final petsSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('pets')
        .get();

    // One count per pet, fetched in parallel rather than one after another.
    final counts = await Future.wait([
      for (final petDoc in petsSnapshot.docs)
        _checksRef(userId, petDoc.id)
            .where('checked_at', isGreaterThanOrEqualTo: startOfMonth)
            .count()
            .get()
            .then((aggregate) => aggregate.count ?? 0),
    ]);
    return counts.fold<int>(0, (total, n) => total + n) >= freeMonthlyLimit;
  }
}
