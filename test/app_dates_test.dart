import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/l10n/app_localizations.dart';
import 'package:pawhealth/models/vaccination.dart';
import 'package:pawhealth/utils/app_dates.dart';
import 'package:pawhealth/widgets/health/add_vaccine_dialog.dart';

Widget _app(Locale locale, Widget home) => MaterialApp(
  locale: locale,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: home,
);

void main() {
  final date = DateTime(2026, 9, 11);

  for (final (locale, expected) in [
    (const Locale('en'), 'Sep 11, 2026'),
    (const Locale('th'), '11 ก.ย. 2569'),
    (const Locale('zh'), '2026年9月11日'),
  ]) {
    testWidgets('formats dates in ${locale.languageCode}', (tester) async {
      late String formatted;
      await tester.pumpWidget(
        _app(
          locale,
          Builder(
            builder: (context) {
              formatted = AppDates.medium(context).format(date);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(formatted, expected);
    });
  }

  testWidgets('Thai years are Buddhist Era, even on a leap day', (
    tester,
  ) async {
    late String formatted;
    await tester.pumpWidget(
      _app(
        const Locale('th'),
        Builder(
          builder: (context) {
            // 2567 B.E. isn't a leap year in the Gregorian rules — the day
            // must not roll over to 1 March.
            formatted = AppDates.medium(context).format(DateTime(2024, 2, 29));
            return const SizedBox();
          },
        ),
      ),
    );
    expect(formatted, '29 ก.พ. 2567');
  });

  testWidgets('the vaccine dialog shows Thai dates in Thai', (tester) async {
    await tester.pumpWidget(
      _app(
        const Locale('th'),
        Builder(
          builder: (context) => TextButton(
            onPressed: () => AddVaccineDialog.show(
              context,
              existing: Vaccination(
                id: 'v1',
                name: 'Rabies',
                dateAdministered: date,
                nextDueDate: DateTime(2027, 9, 11),
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.textContaining('11 ก.ย. 2569'), findsOneWidget);
    expect(find.textContaining('Sep'), findsNothing);
  });
}
