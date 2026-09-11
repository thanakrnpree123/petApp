import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pawhealth/l10n/app_localizations.dart';
import 'package:pawhealth/l10n/app_localizations_en.dart';
import 'package:pawhealth/models/health_log.dart';
import 'package:pawhealth/utils/validators.dart';
import 'package:pawhealth/widgets/health/weight_chart.dart';

HealthLog _weight(double kg, DateTime at) =>
    HealthLog(type: HealthLogType.weight, value: kg, loggedAt: at);

void main() {
  final l10n = AppLocalizationsEn();

  group('Validators.weightKg', () {
    test('accepts plausible weights, with a dot or a decimal comma', () {
      expect(Validators.weightKg('4.5', l10n), isNull);
      expect(Validators.weightKg('4,5', l10n), isNull);
      expect(Validators.parseWeight(' 4,5 '), 4.5);
      expect(Validators.weightKg('0.1', l10n), isNull);
      expect(Validators.weightKg('150', l10n), isNull);
    });

    test('rejects unit slips and impossible values', () {
      // 4500 = grams typed into a kilogram field.
      expect(Validators.weightKg('4500', l10n), l10n.weightOutOfRange);
      expect(Validators.weightKg('0', l10n), l10n.weightOutOfRange);
      expect(Validators.weightKg('-3', l10n), l10n.weightOutOfRange);
    });

    test('rejects non-numbers', () {
      expect(Validators.weightKg('', l10n), l10n.enterValidWeight);
      expect(Validators.weightKg('heavy', l10n), l10n.enterValidWeight);
    });
  });

  group('WeightChart', () {
    test('spaces points by date, not by index', () {
      final (:spots, :origin) = WeightChart.spotsFor([
        _weight(5.2, DateTime(2026, 3, 1)),
        _weight(4.8, DateTime(2026, 1, 1)),
        _weight(5.0, DateTime(2026, 1, 2)),
      ]);

      expect(origin, DateTime(2026, 1, 1));
      expect(spots.map((s) => s.x), [0, 1, 59]); // sorted, real day gaps
      expect(spots.map((s) => s.y), [4.8, 5.0, 5.2]);
    });

    test('labels dates in the locale\'s day/month order', () async {
      await initializeDateFormatting('th');
      await initializeDateFormatting('en');
      final date = DateTime(2026, 9, 19);

      expect(WeightChart.dateLabel(date, 'th'), '19/9');
      expect(WeightChart.dateLabel(date, 'en'), '9/19');
    });

    testWidgets('renders in Thai without errors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('th'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: WeightChart(
              weightLogs: [
                _weight(0.4, DateTime(2026, 1, 1)),
                _weight(0.6, DateTime(2026, 1, 15)),
                _weight(1.1, DateTime(2026, 3, 1)),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('1/1'), findsOneWidget); // first label, d/M order
    });
  });
}
