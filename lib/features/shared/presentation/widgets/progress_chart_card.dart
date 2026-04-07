import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smartfit/app/theme/tokens/app_colors.dart';
import 'package:smartfit/app/theme/tokens/app_spacing.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_interactive_surface.dart';

class ProgressChartBar {
  const ProgressChartBar({required this.label, required this.value});

  final String label;
  final double value;
}

class ProgressChartCard extends StatelessWidget {
  const ProgressChartCard({
    required this.title,
    required this.subtitle,
    required this.bars,
    super.key,
  });

  final String title;
  final String subtitle;
  final List<ProgressChartBar> bars;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxY = bars.fold<double>(0, (current, bar) => bar.value > current ? bar.value : current) + 10;

    return AppInteractiveSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(subtitle, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= bars.length) {
                          return const SizedBox.shrink();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.sm),
                          child: Text(
                            bars[index].label,
                            style: theme.textTheme.bodySmall,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: [
                  for (var index = 0; index < bars.length; index++)
                    BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: bars[index].value,
                          width: 18,
                          borderRadius: BorderRadius.circular(10),
                          color: index == bars.length - 1 ? AppColors.accentStrong : AppColors.info,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}