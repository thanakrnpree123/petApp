import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/care_log.dart';
import '../models/health_log.dart';
import '../models/vaccination.dart';

class HealthLogService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _petDoc(String userId, String petId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('pets')
        .doc(petId);
  }

  CollectionReference<Map<String, dynamic>> _logsRef(
    String userId,
    String petId,
  ) => _petDoc(userId, petId).collection('health_logs');

  CollectionReference<Map<String, dynamic>> _vaccinationsRef(
    String userId,
    String petId,
  ) => _petDoc(userId, petId).collection('vaccinations');

  Stream<List<HealthLog>> watchLogs(String userId, String petId) {
    return _logsRef(userId, petId)
        .orderBy('logged_at', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => HealthLog.fromFirestore(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> addLog(String userId, String petId, HealthLog log) {
    return _logsRef(userId, petId).add(log.toFirestore());
  }

  Stream<List<Vaccination>> watchVaccinations(String userId, String petId) {
    return _vaccinationsRef(userId, petId)
        .orderBy('next_due_at')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Vaccination.fromFirestore(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<String> addVaccination(
    String userId,
    String petId,
    Vaccination vaccination,
  ) async {
    final doc = await _vaccinationsRef(
      userId,
      petId,
    ).add(vaccination.toFirestore());
    return doc.id;
  }

  CollectionReference<Map<String, dynamic>> _careLogsRef(
    String userId,
    String petId,
  ) => _petDoc(userId, petId).collection('care_logs');

  Stream<List<CareLog>> watchCareLogs(String userId, String petId) {
    return _careLogsRef(userId, petId)
        .orderBy('logged_at', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CareLog.fromFirestore(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> addCareLog(String userId, String petId, CareLog log) {
    return _careLogsRef(userId, petId).add(log.toFirestore());
  }

  Future<void> updateCareLog(String userId, String petId, CareLog log) {
    return _careLogsRef(userId, petId).doc(log.id).update(log.toFirestore());
  }

  Future<void> deleteCareLog(String userId, String petId, String logId) {
    return _careLogsRef(userId, petId).doc(logId).delete();
  }

  Future<void> updateVaccination(
    String userId,
    String petId,
    Vaccination vaccination,
  ) {
    return _vaccinationsRef(
      userId,
      petId,
    ).doc(vaccination.id).update(vaccination.toFirestore());
  }

  Future<void> deleteVaccination(
    String userId,
    String petId,
    String vaccinationId,
  ) {
    return _vaccinationsRef(userId, petId).doc(vaccinationId).delete();
  }
}
