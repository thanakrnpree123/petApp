import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pawhealth/data/decision_trees/decision_tree.dart';
import 'package:pawhealth/data/decision_trees/dog_vomiting_tree.dart';
import 'package:pawhealth/l10n/app_localizations_en.dart';
import 'package:pawhealth/l10n/app_localizations_th.dart';
import 'package:pawhealth/l10n/app_localizations_zh.dart';

import 'package:pawhealth/models/care_log.dart';
import 'package:pawhealth/models/health_log.dart';
import 'package:pawhealth/models/pet.dart';
import 'package:pawhealth/models/symptom_check.dart';
import 'package:pawhealth/models/vaccination.dart';
import 'package:pawhealth/services/pdf_report_service.dart';
import 'package:pawhealth/utils/l10n_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // The app loads these through its localization delegates.
  setUpAll(initializeDateFormatting);

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
      l10n: AppLocalizationsTh(),
      compress: false,
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
    expect(_embeddedFonts(bytes), contains('NotoSansThai-Regular'));
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
      l10n: AppLocalizationsEn(),
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

  test('buildReport renders the widened clinical tables', () async {
    // Every optional column switched on at once, in Thai (the widest
    // script the report renders): the tables must still lay out.
    final bytes = await PdfReportService().buildReport(
      pet: Pet(
        id: 'p4',
        name: 'แคทนิป',
        species: PetSpecies.cat,
        breed: 'American Shorthair',
        breedDisorders: const [],
        birthdate: DateTime(2025, 9, 16),
        weightKg: 2.1,
      ),
      l10n: AppLocalizationsTh(),
      compress: false,
      vaccinations: [
        Vaccination(
          id: 'v1',
          name: 'Felocell CVR',
          dateAdministered: DateTime(2026, 9, 16),
          nextDueDate: DateTime(2026, 10, 14),
          veterinarianName: 'ชัชชาลี นิวาสนิรัตน์',
          vetLicenseNo: '01-12444/2561',
          lotNo: '8553JOC',
        ),
      ],
      careLogs: [
        CareLog(
          id: 'c1',
          category: CareCategory.deworming,
          title: 'ถ่ายพยาธิ',
          note: 'ให้พร้อมอาหาร',
          loggedAt: DateTime(2026, 9, 16),
          nextDueDate: DateTime(2026, 10, 14),
          medicine: 'Drontal cat 370g',
          veterinarianName: 'ชัชชาลี นิวาสนิรัตน์',
          vetLicenseNo: '01-12444/2561',
        ),
      ],
    );

    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
    expect(_embeddedFonts(bytes), contains('NotoSansThai-Regular'));
  });

  test('buildReport handles a pet with no records at all', () async {
    final bytes = await PdfReportService().buildReport(
      l10n: AppLocalizationsZh(),
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

  test('a Chinese report embeds the Chinese font', () async {
    final bytes = await PdfReportService().buildReport(
      pet: _pet('小白'),
      l10n: AppLocalizationsZh(),
      compress: false,
    );
    expect(_embeddedFonts(bytes), contains('NotoSansSC-Regular'));
  });

  test('a Chinese pet name renders in any language, not as boxes', () async {
    // Before the Chinese fallback font, this name drew as empty boxes.
    final bytes = await PdfReportService().buildReport(
      pet: _pet('小白'),
      l10n: AppLocalizationsEn(),
      compress: false,
    );
    expect(_embeddedFonts(bytes), contains('NotoSansSC-Regular'));
  });

  test(
    'an English report without other scripts embeds no extra fonts',
    () async {
      final bytes = await PdfReportService().buildReport(
        pet: _pet('Rex'),
        l10n: AppLocalizationsEn(),
        compress: false,
      );
      expect(_embeddedFonts(bytes), isNot(contains('NotoSansSC-Regular')));
      expect(_embeddedFonts(bytes), isNot(contains('NotoSansThai-Regular')));
    },
  );

  test('a saved symptom check is reported in the app language', () async {
    final start = dogVomitingTree['start']! as QuestionNode;
    final saved = SymptomCheck(
      symptomId: dogVomitingSymptomId,
      answers: [
        SymptomAnswer(
          questionId: start.id,
          questionText: start.questionText,
          answer: '1 time',
        ),
      ],
      triageLevel: TriageLevel.monitor,
      advice: (dogVomitingTree['result_monitor_mild']! as ResultNode).advice,
      checkedAt: DateTime(2026, 9, 1),
    );
    final th = AppLocalizationsTh();

    final answer = L10nHelpers.savedAnswer(th, saved, saved.answers.single);
    expect(answer.question, th.qVomitFrequency);
    expect(answer.answer, isNot('1 time'));
    expect(L10nHelpers.savedAdvice(th, saved), th.advMonitorMild);

    final bytes = await PdfReportService().buildReport(
      pet: _pet('Mochi'),
      l10n: th,
      latestCheck: saved,
      compress: false,
    );
    expect(_embeddedFonts(bytes), contains('NotoSansThai-Regular'));
  });

  test('answers no longer in the tree stay as saved', () {
    final saved = SymptomCheck(
      symptomId: dogVomitingSymptomId,
      answers: const [
        SymptomAnswer(
          questionId: 'retired_node',
          questionText: 'Old question?',
          answer: 'Old answer',
        ),
      ],
      triageLevel: TriageLevel.vet,
      advice: 'Old advice.',
      checkedAt: DateTime(2026, 1, 1),
    );
    final answer = L10nHelpers.savedAnswer(
      AppLocalizationsTh(),
      saved,
      saved.answers.single,
    );
    expect(answer.question, 'Old question?');
    expect(answer.answer, 'Old answer');
  });
}

Pet _pet(String name) => Pet(
  id: 'p',
  name: name,
  species: PetSpecies.dog,
  breed: '',
  breedDisorders: const [],
  birthdate: DateTime(2024, 1, 1),
  weightKg: 9,
);

/// Font names embedded in an uncompressed PDF (/BaseFont /ABCDEF+Name).
Set<String> _embeddedFonts(List<int> bytes) => {
  for (final m in RegExp(
    r'/BaseFont\s*/(?:[A-Z]{6}\+)?([A-Za-z0-9-]+)',
  ).allMatches(String.fromCharCodes(bytes)))
    m.group(1)!,
};
