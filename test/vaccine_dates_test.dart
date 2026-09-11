import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/l10n/app_localizations.dart';
import 'package:pawhealth/l10n/app_localizations_en.dart';
import 'package:pawhealth/models/vaccination.dart';
import 'package:pawhealth/widgets/health/add_vaccine_dialog.dart';

void main() {
  final l10n = AppLocalizationsEn();

  group('AddVaccineDialog.dueDateError', () {
    test('next due on a later day is valid', () {
      expect(
        AddVaccineDialog.dueDateError(
          DateTime(2026, 9, 1, 18),
          DateTime(2027, 9, 1),
          l10n,
        ),
        isNull,
      );
    });

    test('next due before — or on the same day as — the shot is rejected', () {
      expect(
        AddVaccineDialog.dueDateError(
          DateTime(2026, 9, 1),
          DateTime(2026, 8, 1),
          l10n,
        ),
        l10n.nextDueBeforeGivenError,
      );
      expect(
        AddVaccineDialog.dueDateError(
          DateTime(2026, 9, 1, 8),
          DateTime(2026, 9, 1, 20),
          l10n,
        ),
        l10n.nextDueBeforeGivenError,
      );
    });

    test('a missing next due date asks for one', () {
      expect(
        AddVaccineDialog.dueDateError(DateTime(2026, 9, 1), null, l10n),
        l10n.selectNextDueDateError,
      );
    });
  });

  test('clampDate keeps picker initial dates in range', () {
    final first = DateTime(2026, 1, 1);
    final last = DateTime(2026, 12, 31);
    expect(AddVaccineDialog.clampDate(DateTime(2030, 1, 1), first, last), last);
    expect(
      AddVaccineDialog.clampDate(DateTime(2020, 1, 1), first, last),
      first,
    );
    expect(
      AddVaccineDialog.clampDate(DateTime(2026, 6, 1), first, last),
      DateTime(2026, 6, 1),
    );
  });

  Future<VaccineDialogResult?> openAndSave(
    WidgetTester tester,
    Vaccination existing,
  ) async {
    VaccineDialogResult? result;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async => result = await AddVaccineDialog.show(
              context,
              existing: existing,
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    return result;
  }

  testWidgets('an invalid saved record is caught on Save', (tester) async {
    final result = await openAndSave(
      tester,
      Vaccination(
        id: 'v1',
        name: 'Rabies',
        dateAdministered: DateTime(2026, 9, 1),
        nextDueDate: DateTime(2026, 3, 1),
      ),
    );

    expect(result, isNull);
    expect(find.text(l10n.nextDueBeforeGivenError), findsOneWidget);
  });

  testWidgets('a valid record saves', (tester) async {
    final result = await openAndSave(
      tester,
      Vaccination(
        id: 'v1',
        name: 'Rabies',
        dateAdministered: DateTime(2026, 9, 1),
        nextDueDate: DateTime(2027, 9, 1),
      ),
    );

    expect(result, isA<VaccineSaved>());
  });
}
