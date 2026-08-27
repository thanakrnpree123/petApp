import 'package:flutter_test/flutter_test.dart';

import 'package:pawhealth/models/care_log.dart';
import 'package:pawhealth/models/health_log.dart';
import 'package:pawhealth/models/pet.dart';
import 'package:pawhealth/models/vaccination.dart';
import 'package:pawhealth/services/pdf_report_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('buildReport renders a valid PDF including Thai text', () async {
    final pet = Pet(
      id: 'p1',
      name: 'น้องเบลล่า',
      species: PetSpecies.dog,
      breed: 'บางแก้ว',
      breedDisorders: const ['hip_dysplasia'],
      birthdate: DateTime(2024, 3, 10),
      weightKg: 18.2,
      gender: PetGender.female,
      isNeutered: true,
      microchipId: '981000012345678',
      allergies: 'แพ้ไก่ และเพนิซิลลิน',
    );

    final bytes = await PdfReportService().buildReport(
      pet: pet,
      vaccinations: [
        Vaccination(
          id: 'v1',
          name: 'พิษสุนัขบ้า (Rabies)',
          dateAdministered: DateTime(2026, 5, 10),
          nextDueDate: DateTime(2027, 5, 10),
        ),
      ],
      careLogs: [
        CareLog(
          id: 'c1',
          category: CareCategory.grooming,
          title: 'อาบน้ำตัดขน',
          note: 'ตัดเล็บด้วย',
          loggedAt: DateTime(2026, 7, 1),
        ),
      ],
    );

    expect(bytes.length, greaterThan(1000));
    // %PDF magic bytes prove a structurally valid document was produced.
    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
  });

  test('buildReport renders the weight range and an "other" category log '
      'without throwing (covers the min–max separator and category '
      'capitalization fixes)', () async {
    final pet = Pet(
      id: 'p3',
      name: 'Milo',
      species: PetSpecies.cat,
      breed: 'Siamese',
      breedDisorders: const [],
      birthdate: DateTime(2023, 1, 1),
      weightKg: 4.0,
    );

    final bytes = await PdfReportService().buildReport(
      pet: pet,
      recentWeightLogs: [
        HealthLog(
          type: HealthLogType.weight,
          value: 17.0,
          loggedAt: DateTime(2026, 1, 1),
        ),
        HealthLog(
          type: HealthLogType.weight,
          value: 60.0,
          loggedAt: DateTime(2026, 6, 1),
        ),
      ],
      careLogs: [
        CareLog(
          id: 'c2',
          category: CareCategory.other,
          title: 'Annual checkup',
          loggedAt: DateTime(2026, 5, 1),
        ),
      ],
    );

    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
  });

  test('buildReport handles a pet with no records at all', () async {
    final bytes = await PdfReportService().buildReport(
      pet: Pet(
        id: 'p2',
        name: 'Rex',
        species: PetSpecies.exotic,
        breed: '',
        breedDisorders: const [],
        birthdate: DateTime(2026, 1, 1),
        weightKg: 0.5,
      ),
    );

    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
  });
}
