import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/health_log.dart';

class WeightChart extends StatelessWidget {
  final List<HealthLog> weightLogs;

  const WeightChart({super.key, required this.weightLogs});

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

    final sorted = [...weightLogs]
      ..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
    final spots = [
      for (var i = 0; i < sorted.length; i++)
        FlSpot(i.toDouble(), sorted[i].value ?? 0),
    ];

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
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
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= sorted.length) {
                    return const SizedBox.shrink();
                  }
                  final date = sorted[index].loggedAt;
                  return SideTitleWidget(
                    meta: meta,
                    child: Text('${date.month}/${date.day}', style: axisStyle),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                getTitlesWidget: (value, meta) =>
                    Text('${value.toInt()}kg', style: axisStyle),
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
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
