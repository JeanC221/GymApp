import 'package:flutter/material.dart';
import 'package:smartfit/app/theme/tokens/app_spacing.dart';
import 'package:smartfit/features/shared/presentation/layouts/app_page_scaffold.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_interactive_surface.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_segmented_control.dart';
import 'package:smartfit/features/shared/presentation/widgets/progress_chart_card.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  static const routeName = 'progress';
  static const routePath = '/progress';

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  String selectedMode = 'exercise';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppPageScaffold(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Progress', style: theme.textTheme.displaySmall),
          const SizedBox(height: AppSpacing.sm),
          Text('Exercise and overall trends', style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Phase 3 keeps this as representative shell content. Real queries and filters land in later phases once feature data is wired.',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
      child: ListView(
        children: [
          AppSegmentedControl<String>(
            value: selectedMode,
            segments: const [
              AppSegment(value: 'exercise', label: 'Exercise', icon: Icons.fitness_center),
              AppSegment(value: 'overall', label: 'Overall', icon: Icons.insights_outlined),
            ],
            onChanged: (value) => setState(() => selectedMode = value),
          ),
          const SizedBox(height: AppSpacing.xl),
          if (selectedMode == 'exercise') ...[
            const ProgressChartCard(
              title: 'Bench press progress',
              subtitle: 'Completed sets only, last 6 weeks',
              bars: [
                ProgressChartBar(label: 'W1', value: 58),
                ProgressChartBar(label: 'W2', value: 60),
                ProgressChartBar(label: 'W3', value: 60),
                ProgressChartBar(label: 'W4', value: 62.5),
                ProgressChartBar(label: 'W5', value: 62.5),
                ProgressChartBar(label: 'W6', value: 65),
              ],
            ),
          ] else ...[
            const ProgressChartCard(
              title: 'Weekly completion',
              subtitle: 'Sessions completed against plan',
              bars: [
                ProgressChartBar(label: 'W1', value: 2),
                ProgressChartBar(label: 'W2', value: 3),
                ProgressChartBar(label: 'W3', value: 2),
                ProgressChartBar(label: 'W4', value: 4),
                ProgressChartBar(label: 'W5', value: 3),
                ProgressChartBar(label: 'W6', value: 4),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          AppInteractiveSurface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Last used weight is reference only', style: theme.textTheme.titleLarge),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'The UI can preview recent performance here, but session inputs should still be explicit and never silently autofilled.',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}