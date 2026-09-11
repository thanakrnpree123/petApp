import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../models/health_log.dart';

class WeightChart extends StatelessWidget {
  final List<HealthLog> weightLogs;

  const WeightChart({super.key, required this.weightLogs});

  /// Plots each log at its real date — x is days since the first log — so
  /// a gap of two months looks like two months, not like the next day.
  @visibleForTesting
  static ({List<FlSpot> spots, DateTime origin}) spotsFor(
    List<HealthLog> logs,
  ) {
    final sorted = [...logs]..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
    final origin = sorted.first.loggedAt;
    return (
      spots: [
        for (final log in sorted)
          FlSpot(_daysBetween(origin, log.loggedAt), log.value ?? 0),
      ],
      origin: origin,
    );
  }

  static double _daysBetween(DateTime from, DateTime to) =>
      to.difference(from).inMinutes / Duration.minutesPerDay;

  /// Day and month in the order the locale expects (19/9 in Thai, 9/19 in
  /// US English).
  @visibleForTesting
  static String dateLabel(DateTime date, String locale) =>
      DateFormat.Md(locale).format(date);

  static final _weightFormat = NumberFormat('0.#');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final axisStyle = theme.textTheme.labelSmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
    );

    if (weightLogs.length < 2) {
      return SizedBox(
        height: 160,
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.weightChartNeedTwo,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    final locale = Localizations.localeOf(context).toString();
    final (:spots, :origin) = spotsFor(weightLogs);
    // Logs all on one day would give a zero-width axis.
    final span = spots.last.x > 0 ? spots.last.x : 1.0;
    // About four date labels across the axis, never closer than a day.
    final labelInterval = span / 4 < 1 ? 1.0 : span / 4;

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: span,
          minY: 0,
          // Horizontal guides only, in the hairline color — the line is
          // the content, the grid just helps read values off it.
          gridData: FlGridData(
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: colorScheme.outlineVariant, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: labelInterval,
                getTitlesWidget: (value, meta) {
                  final date = origin.add(
                    Duration(minutes: (value * Duration.minutesPerDay).round()),
                  );
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(dateLabel(date, locale), style: axisStyle),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                getTitlesWidget: (value, meta) =>
                    Text('${_weightFormat.format(value)}kg', style: axisStyle),
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              // Keeps the curve from overshooting between uneven points.
              preventCurveOverShooting: true,
              color: colorScheme.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                getDotPainter: (_, _, _, _) => FlDotCirclePainter(
                  radius: 4,
                  color: colorScheme.surface,
                  strokeWidth: 2.5,
                  strokeColor: colorScheme.primary,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: colorScheme.primary.withValues(alpha: 0.08),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
