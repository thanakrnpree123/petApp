import 'package:cloud_firestore/cloud_firestore.dart';

enum CareCategory {
  /// Intestinal worms — the notebook's "ถ่ายพยาธิ / DEWORMING" table.
  deworming('deworming'),

  /// Fleas, ticks and mites — the notebook's
  /// "ป้องกันปรสิตภายนอก / ANTI-ECTOPARASITE" table.
  ectoparasite('ectoparasite'),

  heatCycle('heat_cycle'),
  medicalSurgery('medical_surgery'),
  grooming('grooming'),
  other('other'),

  /// Legacy: before internal and external parasites were split, both were
  /// logged under one "Parasite Control" category. Which of the two a
  /// given record meant can't be inferred from the stored data, so old
  /// documents keep this value and their original label rather than being
  /// silently relabelled. It's offered in the category picker only for a
  /// record that already carries it, so editing one is how it gets
  /// reclassified — and nothing new is ever written with it.
  parasiteControl('parasite_control');

  const CareCategory(this.value);

  /// Canonical Firestore value (stable across app versions and locales).
  final String value;

  /// The categories a user can pick for a new record, in display order.
  /// [parasiteControl] is deliberately absent — see its doc comment.
  static const selectable = [
    deworming,
    ectoparasite,
    medicalSurgery,
    grooming,
    heatCycle,
    other,
  ];

  /// Whether this category is retained only to read older documents.
  bool get isLegacy => this == parasiteControl;

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

  /// When this care is due again — the notebook's "นัดครั้งต่อไป / Next
  /// appointment" line. Null for one-off records.
  final DateTime? nextDueDate;

  /// Whether to schedule a local reminder ahead of [nextDueDate]. Ignored
  /// when there's no next due date to remind about.
  final bool reminderEnabled;

  CareLog({
    this.id,
    required this.category,
    required this.title,
    this.note = '',
    required this.loggedAt,
    this.nextDueDate,
    this.reminderEnabled = true,
  });

  /// Whether a reminder should exist for this record at all.
  bool get hasReminder => nextDueDate != null && reminderEnabled;

  CareLog copyWith({String? id}) => CareLog(
    id: id ?? this.id,
    category: category,
    title: title,
    note: note,
    loggedAt: loggedAt,
    nextDueDate: nextDueDate,
    reminderEnabled: reminderEnabled,
  );

  factory CareLog.fromFirestore(String id, Map<String, dynamic> data) {
    return CareLog(
      id: id,
      category: CareCategory.fromValue(data['category'] as String),
      // Pre-title documents fall back to showing their note as the title.
      title: data['title'] as String? ?? data['note'] as String? ?? '',
      note: data['note'] as String? ?? '',
      loggedAt: (data['logged_at'] as Timestamp).toDate(),
      // Absent on every document written before next due dates existed.
      nextDueDate: (data['next_due_at'] as Timestamp?)?.toDate(),
      reminderEnabled: data['reminder_enabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'category': category.value,
      'title': title,
      'note': note,
      'logged_at': Timestamp.fromDate(loggedAt),
      // Written as null (not omitted) so clearing a next due date on an
      // update actually removes it from the document.
      'next_due_at': nextDueDate == null
          ? null
          : Timestamp.fromDate(nextDueDate!),
      'reminder_enabled': reminderEnabled,
    };
  }
}
