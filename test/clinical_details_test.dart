import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pawhealth/l10n/app_localizations.dart';
import 'package:pawhealth/l10n/app_localizations_en.dart';
import 'package:pawhealth/models/care_log.dart';
import 'package:pawhealth/models/vaccination.dart';
import 'package:pawhealth/services/report_tables.dart';
import 'package:pawhealth/utils/app_dates.dart';
import 'package:pawhealth/widgets/health/add_health_record_dialog.dart';
import 'package:pawhealth/widgets/health/add_vaccine_dialog.dart';
import 'package:pawhealth/widgets/health/clinical_details_section.dart';

Vaccination _vax({String? vet, String? license, String? lot}) => Vaccination(
  id: 'v1',
  name: 'Felocell CVR',
  dateAdministered: DateTime(2026, 9, 16),
  nextDueDate: DateTime(2026, 10, 14),
  veterinarianName: vet,
  vetLicenseNo: license,
  lotNo: lot,
);

CareLog _care({
  String? medicine,
  String? vet,
  String? license,
  DateTime? due,
}) => CareLog(
  id: 'c1',
  category: CareCategory.deworming,
  title: 'Deworming',
  note: 'Given with food',
  loggedAt: DateTime(2026, 9, 16),
  nextDueDate: due,
  medicine: medicine,
  veterinarianName: vet,
  vetLicenseNo: license,
);

/// Pumps a dialog and collects what it pops.
class _Popped {
  Object? result;
}

Future<_Popped> _open(WidgetTester tester, Widget Function() build) async {
  final popped = _Popped();
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              popped.result = await showDialog<Object?>(
                context: context,
                builder: (_) => build(),
              );
            },
            child: const Text('open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return popped;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final l10n = AppLocalizationsEn();
  // Built after the locale data loads — DateFormat throws without it.
  late final AppDateFormat date;
  setUpAll(() async {
    await initializeDateFormatting();
    date = AppDates.mediumFor(const Locale('en'));
  });

  group('Vaccination clinical fields', () {
    test('a document written before these fields existed still reads', () {
      final vaccination = Vaccination.fromFirestore('v1', {
        'vaccine_name': 'Rabies',
        'administered_at': Timestamp.fromDate(DateTime(2026, 9, 16)),
        'next_due_at': Timestamp.fromDate(DateTime(2027, 9, 16)),
      });

      expect(vaccination.veterinarianName, isNull);
      expect(vaccination.vetLicenseNo, isNull);
      expect(vaccination.lotNo, isNull);
      expect(vaccination.hasClinicalDetails, isFalse);
    });

    test('clinical details round-trip through Firestore', () {
      final data = _vax(
        vet: 'Chutchalee Niwasnilrat',
        license: '01-12444/2561',
        lot: '8553JOC',
      ).toFirestore();

      expect(data['vet_name'], 'Chutchalee Niwasnilrat');
      expect(data['vet_license_no'], '01-12444/2561');
      expect(data['lot_no'], '8553JOC');

      final back = Vaccination.fromFirestore('v1', data);
      expect(back.lotNo, '8553JOC');
      expect(back.hasClinicalDetails, isTrue);
    });

    test('blank input is stored as null, not an empty string', () {
      final vaccination = _vax(vet: '   ', license: '', lot: null);
      expect(vaccination.veterinarianName, isNull);
      expect(vaccination.vetLicenseNo, isNull);
      expect(vaccination.hasClinicalDetails, isFalse);
      // Written as null (not omitted) so clearing a field on an update
      // removes it from the stored document.
      expect(vaccination.toFirestore().containsKey('vet_name'), isTrue);
      expect(vaccination.toFirestore()['vet_name'], isNull);
    });

    test('values are trimmed', () {
      expect(_vax(lot: '  8553JOC  ').lotNo, '8553JOC');
    });
  });

  group('CareLog clinical fields', () {
    test('a document written before these fields existed still reads', () {
      final log = CareLog.fromFirestore('c1', {
        'category': 'deworming',
        'title': 'Drontal',
        'note': '',
        'logged_at': Timestamp.fromDate(DateTime(2026, 9, 16)),
      });

      expect(log.medicine, isNull);
      expect(log.veterinarianName, isNull);
      expect(log.hasClinicalDetails, isFalse);
    });

    test('medicine and vet round-trip through Firestore', () {
      final data = _care(
        medicine: 'Drontal cat 370g',
        vet: 'Chutchalee Niwasnilrat',
        license: '01-12444/2561',
      ).toFirestore();

      expect(data['medicine'], 'Drontal cat 370g');
      expect(data['vet_name'], 'Chutchalee Niwasnilrat');

      final back = CareLog.fromFirestore('c1', data);
      expect(back.medicine, 'Drontal cat 370g');
      expect(back.hasClinicalDetails, isTrue);
    });

    test('copyWith carries the clinical details', () {
      // The dashboard copies a saved log to attach its new Firestore id.
      final log = _care(
        medicine: 'Revolution',
        vet: 'Dr Aran',
      ).copyWith(id: 'new-id');
      expect(log.id, 'new-id');
      expect(log.medicine, 'Revolution');
      expect(log.veterinarianName, 'Dr Aran');
    });
  });

  group('ReportTables.vetLabel', () {
    test('pairs the name with the licence when both exist', () {
      expect(
        ReportTables.vetLabel('Chutchalee Niwasnilrat', '01-12444/2561'),
        'Chutchalee Niwasnilrat (01-12444/2561)',
      );
    });

    test('falls back to whichever half was recorded', () {
      expect(ReportTables.vetLabel('Dr Aran', null), 'Dr Aran');
      expect(ReportTables.vetLabel(null, '01-12444/2561'), '01-12444/2561');
      expect(ReportTables.vetLabel(null, null), '');
    });
  });

  group('ReportTables.vaccinations', () {
    test('a report with no clinical details keeps its original columns', () {
      final table = ReportTables.vaccinations(l10n, date, [_vax()]);

      expect(table.headers, [
        l10n.pdfVaccine,
        l10n.pdfAdministered,
        l10n.pdfNextDue,
      ]);
      expect(table.rows.single.length, 3);
      expect(table.flexWidths.keys, [0, 1, 2]);
    });

    test('lot and vet columns appear once any record fills them in', () {
      final table = ReportTables.vaccinations(l10n, date, [
        _vax(
          vet: 'Chutchalee Niwasnilrat',
          license: '01-12444/2561',
          lot: '8553JOC',
        ),
        _vax(), // a record without them still renders, just blank
      ]);

      expect(table.headers, [
        l10n.pdfVaccine,
        l10n.pdfAdministered,
        l10n.pdfNextDue,
        l10n.pdfLotNo,
        l10n.pdfVeterinarian,
      ]);
      expect(table.rows.first[3], '8553JOC');
      expect(table.rows.first[4], 'Chutchalee Niwasnilrat (01-12444/2561)');
      expect(table.rows.last[3], '');
      expect(table.rows.last[4], '');
      expect(table.flexWidths.length, table.headers.length);
    });

    test('the vet column appears for a licence with no name', () {
      final table = ReportTables.vaccinations(l10n, date, [
        _vax(license: '01-12444/2561'),
      ]);
      expect(table.headers, contains(l10n.pdfVeterinarian));
      expect(table.headers, isNot(contains(l10n.pdfLotNo)));
    });
  });

  group('ReportTables.careLogs', () {
    test('a report with no clinical details keeps its original columns', () {
      final table = ReportTables.careLogs(l10n, date, [_care()]);

      expect(table.headers, [
        l10n.pdfDate,
        l10n.pdfCategory,
        l10n.pdfEntry,
        l10n.pdfDetails,
      ]);
    });

    test('medicine, next due and vet columns appear when filled in', () {
      final table = ReportTables.careLogs(l10n, date, [
        _care(
          medicine: 'Drontal cat 370g',
          vet: 'Chutchalee Niwasnilrat',
          license: '01-12444/2561',
          due: DateTime(2026, 10, 14),
        ),
      ]);

      expect(table.headers, [
        l10n.pdfDate,
        l10n.pdfCategory,
        l10n.pdfEntry,
        l10n.pdfMedicine,
        l10n.pdfNextDue,
        l10n.pdfVeterinarian,
        // Details stays last: widest and least structured.
        l10n.pdfDetails,
      ]);
      final row = table.rows.single;
      expect(row[3], 'Drontal cat 370g');
      expect(row[4], date.format(DateTime(2026, 10, 14)));
      expect(row[5], 'Chutchalee Niwasnilrat (01-12444/2561)');
      expect(row[6], 'Given with food');
    });
  });

  group('Clinical details in the dialogs', () {
    testWidgets('a vaccination saves the vet, licence and lot number', (
      tester,
    ) async {
      // Started from an existing record: a new one can't be saved until a
      // next due date is picked, which isn't what this test is about.
      final popped = await _open(
        tester,
        () => AddVaccineDialog(existing: _vax()),
      );

      // Collapsed by default so the everyday path stays short.
      expect(
        find.widgetWithText(TextFormField, l10n.vaccineLotNo),
        findsNothing,
      );
      await tester.tap(find.text(l10n.clinicalDetails));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, l10n.vaccineLotNo),
        '8553JOC',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, l10n.veterinarianName),
        'Chutchalee Niwasnilrat',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, l10n.vetLicenseNo),
        '01-12444/2561',
      );
      await tester.tap(find.text(l10n.save));
      await tester.pumpAndSettle();

      final saved = popped.result as VaccineSaved;
      expect(saved.vaccination.lotNo, '8553JOC');
      expect(saved.vaccination.veterinarianName, 'Chutchalee Niwasnilrat');
      expect(saved.vaccination.vetLicenseNo, '01-12444/2561');
    });

    testWidgets('editing a record with details opens the section expanded', (
      tester,
    ) async {
      await _open(
        tester,
        () => AddVaccineDialog(existing: _vax(lot: '8553JOC')),
      );

      // Nothing worth editing should be hidden behind a tap.
      expect(
        find.widgetWithText(TextFormField, l10n.vaccineLotNo),
        findsOneWidget,
      );
    });

    testWidgets('a care record saves its medicine and dose', (tester) async {
      final popped = await _open(tester, () => const AddHealthRecordDialog());

      await tester.enterText(
        find.widgetWithText(TextFormField, l10n.careTitle),
        'Deworming',
      );
      await tester.tap(find.text(l10n.clinicalDetails));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, l10n.medicineLabel),
        'Drontal cat 370g',
      );
      await tester.tap(find.text(l10n.save));
      await tester.pumpAndSettle();

      final saved = popped.result as HealthRecordSaved;
      expect(saved.log.medicine, 'Drontal cat 370g');
      expect(saved.log.veterinarianName, isNull);
    });

    testWidgets('both dialogs share one clinical details section', (
      tester,
    ) async {
      await _open(tester, () => const AddHealthRecordDialog());
      expect(find.byType(ClinicalDetailsSection), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await _open(tester, () => const AddVaccineDialog());
      expect(find.byType(ClinicalDetailsSection), findsOneWidget);
    });
  });
}
