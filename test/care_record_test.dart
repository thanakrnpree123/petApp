import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/l10n/app_localizations.dart';
import 'package:pawhealth/l10n/app_localizations_en.dart';
import 'package:pawhealth/models/care_log.dart';
import 'package:pawhealth/providers/health_timeline_provider.dart';
import 'package:pawhealth/utils/l10n_helpers.dart';
import 'package:pawhealth/widgets/health/add_health_record_dialog.dart';

/// Collects what the dialog pops; read it after the dialog closes.
class _Popped {
  HealthRecordDialogResult? result;
}

Future<_Popped> _showDialog(WidgetTester tester, {CareLog? existing}) async {
  final popped = _Popped();
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              popped.result = await AddHealthRecordDialog.show(
                context,
                existing: existing,
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

CareLog _log({
  String? id,
  CareCategory category = CareCategory.other,
  DateTime? nextDueDate,
  bool reminderEnabled = true,
}) => CareLog(
  id: id,
  category: category,
  title: 'Drontal',
  loggedAt: DateTime(2026, 9, 16),
  nextDueDate: nextDueDate,
  reminderEnabled: reminderEnabled,
);

void main() {
  final l10n = AppLocalizationsEn();

  group('CareCategory', () {
    test('the legacy parasite_control value still reads back', () {
      // Documents written before deworming and ectoparasite were split
      // must keep their own category rather than silently becoming
      // something they never were.
      expect(
        CareCategory.fromValue('parasite_control'),
        CareCategory.parasiteControl,
      );
      expect(CareCategory.parasiteControl.isLegacy, isTrue);
    });

    test('the legacy value is never offered for a new record', () {
      expect(
        CareCategory.selectable,
        isNot(contains(CareCategory.parasiteControl)),
      );
      expect(CareCategory.selectable, contains(CareCategory.deworming));
      expect(CareCategory.selectable, contains(CareCategory.ectoparasite));
      expect(CareCategory.selectable.every((c) => !c.isLegacy), isTrue);
    });

    test('every category round-trips through its stored value', () {
      for (final category in CareCategory.values) {
        expect(CareCategory.fromValue(category.value), category);
      }
    });

    test('an unknown stored value falls back to other', () {
      expect(CareCategory.fromValue('something_new'), CareCategory.other);
    });

    test('every category has a label', () {
      for (final category in CareCategory.values) {
        expect(L10nHelpers.careCategory(l10n, category), isNotEmpty);
      }
    });
  });

  group('filterForCareCategory', () {
    test('deworming and ectoparasite each get their own chip', () {
      expect(
        filterForCareCategory(CareCategory.deworming),
        TimelineFilter.deworming,
      );
      expect(
        filterForCareCategory(CareCategory.ectoparasite),
        TimelineFilter.ectoparasite,
      );
    });

    test('legacy parasite control stays where it has always appeared', () {
      expect(
        filterForCareCategory(CareCategory.parasiteControl),
        TimelineFilter.medical,
      );
    });
  });

  group('CareLog Firestore mapping', () {
    test('a document written before next due dates existed still reads', () {
      final log = CareLog.fromFirestore('c1', {
        'category': 'parasite_control',
        'title': 'Revolution',
        'note': '',
        'logged_at': Timestamp.fromDate(DateTime(2026, 9, 16)),
      });

      expect(log.category, CareCategory.parasiteControl);
      expect(log.nextDueDate, isNull);
      expect(log.reminderEnabled, isTrue);
      expect(log.hasReminder, isFalse);
    });

    test('a next due date and its reminder round-trip', () {
      final data = _log(
        category: CareCategory.deworming,
        nextDueDate: DateTime(2026, 10, 14),
      ).toFirestore();

      expect(data['category'], 'deworming');
      expect(
        (data['next_due_at'] as Timestamp).toDate(),
        DateTime(2026, 10, 14),
      );
      expect(data['reminder_enabled'], isTrue);

      final back = CareLog.fromFirestore('c1', data);
      expect(back.nextDueDate, DateTime(2026, 10, 14));
      expect(back.hasReminder, isTrue);
    });

    test('a cleared next due date is written as null, not omitted', () {
      // Omitting it would leave the old date on the stored document.
      final data = _log().toFirestore();
      expect(data.containsKey('next_due_at'), isTrue);
      expect(data['next_due_at'], isNull);
    });

    test('a switched-off reminder is not a reminder', () {
      final log = _log(
        nextDueDate: DateTime(2026, 10, 14),
        reminderEnabled: false,
      );
      expect(log.hasReminder, isFalse);
    });
  });

  group('AddHealthRecordDialog', () {
    testWidgets('a new record is saved under the category picked', (
      tester,
    ) async {
      // Previously every new record was silently filed as "Other".
      final popped = await _showDialog(tester);

      await tester.tap(find.byType(DropdownButtonFormField<CareCategory>));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.careDeworming).last);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, l10n.careTitle),
        'Drontal',
      );
      await tester.tap(find.text(l10n.save));
      await tester.pumpAndSettle();

      final result = popped.result;
      expect(result, isA<HealthRecordSaved>());
      final log = (result as HealthRecordSaved).log;
      expect(log.category, CareCategory.deworming);
      expect(log.title, 'Drontal');
      expect(log.nextDueDate, isNull);
    });

    testWidgets('re-filing a legacy record drops the legacy category', (
      tester,
    ) async {
      final popped = await _showDialog(
        tester,
        existing: _log(id: 'c1', category: CareCategory.parasiteControl),
      );

      await tester.tap(find.byType(DropdownButtonFormField<CareCategory>));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.careEctoparasite).last);
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.save));
      await tester.pumpAndSettle();

      final result = popped.result;
      expect(result, isA<HealthRecordSaved>());
      expect(
        (result as HealthRecordSaved).log.category,
        CareCategory.ectoparasite,
      );
    });

    testWidgets('an existing next due date is kept when saved again', (
      tester,
    ) async {
      final popped = await _showDialog(
        tester,
        existing: _log(id: 'c1', nextDueDate: DateTime(2099, 10, 14)),
      );

      await tester.tap(find.text(l10n.save));
      await tester.pumpAndSettle();

      final log = (popped.result as HealthRecordSaved).log;
      expect(log.nextDueDate, DateTime(2099, 10, 14));
      expect(log.hasReminder, isTrue);
    });

    testWidgets('clearing the next due date turns the reminder off', (
      tester,
    ) async {
      final popped = await _showDialog(
        tester,
        existing: _log(id: 'c1', nextDueDate: DateTime(2099, 10, 14)),
      );

      await tester.tap(find.byTooltip(l10n.careClearNextDue));
      await tester.pumpAndSettle();
      expect(find.byType(SwitchListTile), findsNothing);

      await tester.tap(find.text(l10n.save));
      await tester.pumpAndSettle();

      final log = (popped.result as HealthRecordSaved).log;
      expect(log.nextDueDate, isNull);
      expect(log.hasReminder, isFalse);
    });

    testWidgets('editing a record pre-selects its own category', (
      tester,
    ) async {
      await _showDialog(
        tester,
        existing: _log(id: 'c1', category: CareCategory.ectoparasite),
      );

      expect(find.text(l10n.careEctoparasite), findsOneWidget);
    });

    testWidgets('a legacy record keeps its label until it is re-filed', (
      tester,
    ) async {
      await _showDialog(
        tester,
        existing: _log(id: 'c1', category: CareCategory.parasiteControl),
      );

      expect(find.text(l10n.careParasiteControl), findsOneWidget);
    });

    testWidgets('the reminder toggle appears only with a next due date', (
      tester,
    ) async {
      await _showDialog(tester, existing: _log(id: 'c1'));
      expect(find.text(l10n.careSelectNextDue), findsOneWidget);
      expect(find.byType(SwitchListTile), findsNothing);

      await tester.pumpWidget(const SizedBox());
      await _showDialog(
        tester,
        existing: _log(id: 'c1', nextDueDate: DateTime(2099, 10, 14)),
      );
      expect(find.byType(SwitchListTile), findsOneWidget);
      expect(find.text(l10n.careRemindMe), findsOneWidget);
    });
  });
}
