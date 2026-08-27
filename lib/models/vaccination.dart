import 'package:cloud_firestore/cloud_firestore.dart';

class Vaccination {
  final String? id;
  final String name;
  final DateTime dateAdministered;
  final DateTime nextDueDate;

  Vaccination({
    this.id,
    required this.name,
    required this.dateAdministered,
    required this.nextDueDate,
  });

  factory Vaccination.fromFirestore(String id, Map<String, dynamic> data) {
    return Vaccination(
      id: id,
      name: data['vaccine_name'] as String,
      dateAdministered: (data['administered_at'] as Timestamp).toDate(),
      nextDueDate: (data['next_due_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'vaccine_name': name,
      'administered_at': Timestamp.fromDate(dateAdministered),
      'next_due_at': Timestamp.fromDate(nextDueDate),
    };
  }
}
