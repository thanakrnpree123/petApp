import 'package:cloud_firestore/cloud_firestore.dart';

enum CareCategory {
  parasiteControl('parasite_control'),
  heatCycle('heat_cycle'),
  medicalSurgery('medical_surgery'),
  grooming('grooming'),
  other('other');

  const CareCategory(this.value);

  /// Canonical Firestore value (stable across app versions and locales).
  final String value;

  static CareCategory fromValue(String value) {
    return CareCategory.values.firstWhere(
      (c) => c.value == value,
      orElse: () => CareCategory.other,
    );
  }
}

class CareLog {
  final String? id;
  final CareCategory category;

  /// Free-text subject, e.g. "Bathing", "Nail trimming".
  final String title;

  /// Free-text details. Kept as `note` in Firestore for backward
  /// compatibility with documents written before titles existed.
  final String note;
  final DateTime loggedAt;

  CareLog({
    this.id,
    required this.category,
    required this.title,
    this.note = '',
    required this.loggedAt,
  });

  factory CareLog.fromFirestore(String id, Map<String, dynamic> data) {
    return CareLog(
      id: id,
      category: CareCategory.fromValue(data['category'] as String),
      // Pre-title documents fall back to showing their note as the title.
      title: data['title'] as String? ?? data['note'] as String? ?? '',
      note: data['note'] as String? ?? '',
      loggedAt: (data['logged_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'category': category.value,
      'title': title,
      'note': note,
      'logged_at': Timestamp.fromDate(loggedAt),
    };
  }
}
