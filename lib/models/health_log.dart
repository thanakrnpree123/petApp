import 'package:cloud_firestore/cloud_firestore.dart';

enum HealthLogType { weight, food, medication, activity, note }

class HealthLog {
  final String? id;
  final HealthLogType type;
  final double? value;
  final String? note;
  final DateTime loggedAt;

  HealthLog({
    this.id,
    required this.type,
    this.value,
    this.note,
    required this.loggedAt,
  });

  factory HealthLog.fromFirestore(String id, Map<String, dynamic> data) {
    return HealthLog(
      id: id,
      type: HealthLogType.values.firstWhere((t) => t.name == data['type']),
      value: (data['value'] as num?)?.toDouble(),
      note: data['note'] as String?,
      loggedAt: (data['logged_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'type': type.name,
      'value': value,
      'note': note,
      'logged_at': Timestamp.fromDate(loggedAt),
    };
  }
}
