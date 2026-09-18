import 'package:cloud_firestore/cloud_firestore.dart';

/// Blank text fields must not be stored as empty strings — "present but
/// empty" and "never filled in" should read back the same.
String? _trimToNull(String? value) {
  final trimmed = value?.trim();
  return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
}

class Vaccination {
  final String? id;
  final String name;
  final DateTime dateAdministered;
  final DateTime nextDueDate;

  /// Clinical provenance, all optional — the vet, their licence, and the
  /// vaccine's lot number, as printed on the sticker a clinic staples into
  /// a paper vaccination book. Boarding, travel and insurance paperwork
  /// routinely asks for the lot number and the administering vet.
  final String? veterinarianName;
  final String? vetLicenseNo;
  final String? lotNo;

  Vaccination({
    this.id,
    required this.name,
    required this.dateAdministered,
    required this.nextDueDate,
    String? veterinarianName,
    String? vetLicenseNo,
    String? lotNo,
  }) : veterinarianName = _trimToNull(veterinarianName),
       vetLicenseNo = _trimToNull(vetLicenseNo),
       lotNo = _trimToNull(lotNo);

  /// Whether any clinical provenance was recorded.
  bool get hasClinicalDetails =>
      veterinarianName != null || vetLicenseNo != null || lotNo != null;

  factory Vaccination.fromFirestore(String id, Map<String, dynamic> data) {
    return Vaccination(
      id: id,
      name: data['vaccine_name'] as String,
      dateAdministered: (data['administered_at'] as Timestamp).toDate(),
      nextDueDate: (data['next_due_at'] as Timestamp).toDate(),
      // Absent on every document written before clinical details existed.
      veterinarianName: data['vet_name'] as String?,
      vetLicenseNo: data['vet_license_no'] as String?,
      lotNo: data['lot_no'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'vaccine_name': name,
      'administered_at': Timestamp.fromDate(dateAdministered),
      'next_due_at': Timestamp.fromDate(nextDueDate),
      // Written even when null so clearing a field on an update actually
      // removes it from the document.
      'vet_name': veterinarianName,
      'vet_license_no': vetLicenseNo,
      'lot_no': lotNo,
    };
  }
}
