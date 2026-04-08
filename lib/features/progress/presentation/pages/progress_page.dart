import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartfit/app/theme/tokens/app_spacing.dart';
import 'package:smartfit/core/domain/enums/exercise_type.dart';
import 'package:smartfit/core/domain/enums/progress_range.dart';
import 'package:smartfit/features/progress/presentation/providers/progress_overview_provider.dart';
import 'package:smartfit/features/progress/presentation/providers/progress_preferences_provider.dart';
import 'package:smartfit/features/shared/presentation/layouts/app_page_scaffold.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_empty_state.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_error_state.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_interactive_surface.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_segmented_control.dart';
import 'package:smartfit/features/shared/presentation/widgets/progress_chart_card.dart';

class ProgressPage extends ConsumerStatefulWidget {
  const ProgressPage({super.key});

  static const routeName = 'progress';
  static const routePath = '/progress';

  @override
  ConsumerState<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends ConsumerState<ProgressPage> {
  String selectedMode = 'exercise';
  ProgressRange selectedRange = ProgressRange.last30Days;
  String? selectedExerciseId;
  bool didHydratePreferredRange = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final preferredRangeAsync = ref.watch(preferredProgressRangeProvider);
    _hydratePreferredRange(preferredRangeAsync);
    final progressAsync = ref.watch(progressOverviewProvider(selectedRange));

    return AppPageScaffold(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Progress', style: theme.textTheme.displaySmall),
          const SizedBox(height: AppSpacing.sm),
          Text('Exercise and overall trends', style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Real progress lives here: historical exercise charts, cardio summaries and last used weight references sourced from actual logs.',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
      child: progressAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => AppErrorState(
          title: 'Could not load progress',
          description: error.toString(),
          onRetry: () => ref.invalidate(progressOverviewProvider(selectedRange)),
        ),
        data: (overview) {
          final selectedExercise = _resolveSelectedExercise(overview);

          return ListView(
            children: [
              AppSegmentedControl<String>(
                value: selectedMode,
                segments: const [
                  AppSegment(value: 'exercise', label: 'Exercise', icon: Icons.fitness_center),
                  AppSegment(value: 'overall', label: 'Overall', icon: Icons.insights_outlined),
                ],
                onChanged: (value) => setState(() => selectedMode = value),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppSegmentedControl<ProgressRange>(
                value: selectedRange,
                segments: const [
                  AppSegment(value: ProgressRange.last30Days, label: '30 days'),
                  AppSegment(value: ProgressRange.last8Weeks, label: '8 weeks'),
                  AppSegment(value: ProgressRange.allTime, label: 'All time'),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedRange = value;
                    didHydratePreferredRange = true;
                  });
                  unawaited(
                    ref
                        .read(progressPreferencesControllerProvider)
                        .savePreferredRange(value),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              if (selectedMode == 'exercise')
                _ExerciseProgressView(
                  overview: overview,
                  selectedExercise: selectedExercise,
                  selectedExerciseId: selectedExerciseId,
                  onExerciseChanged: (value) => setState(() => selectedExerciseId = value),
                )
              else
                _OverallProgressView(overview: overview),
            ],
          );
        },
      ),
    );
  }

  ProgressExerciseHistory? _resolveSelectedExercise(ProgressOverview overview) {
    if (selectedExerciseId != null) {
      final history = overview.historyFor(selectedExerciseId!);
      if (history != null) {
        return history;
      }
    }
    return overview.defaultExerciseHistory;
  }

  void _hydratePreferredRange(AsyncValue<ProgressRange> preferredRangeAsync) {
    preferredRangeAsync.whenData((preferredRange) {
      if (didHydratePreferredRange) {
        return;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || didHydratePreferredRange) {
          return;
        }
        setState(() {
          selectedRange = preferredRange;
          didHydratePreferredRange = true;
        });
      });
    });
  }
}

class _ExerciseProgressView extends StatelessWidget {
  const _ExerciseProgressView({
    required this.overview,
    required this.selectedExercise,
    required this.selectedExerciseId,
    required this.onExerciseChanged,
  });

  final ProgressOverview overview;
  final ProgressExerciseHistory? selectedExercise;
  final String? selectedExerciseId;
  final ValueChanged<String?> onExerciseChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (overview.exerciseHistories.isEmpty) {
      return const AppEmptyState(
        title: 'No exercise templates yet',
        description: 'Build some training days first. Progress becomes useful once real sessions start producing logs.',
      );
    }

    final history = selectedExercise;
    if (history == null) {
      return const AppEmptyState(
        title: 'No exercise selected',
        description: 'Choose an exercise to inspect its real history.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppInteractiveSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tracked exercise', style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                initialValue: selectedExerciseId ?? history.exerciseId,
                decoration: const InputDecoration(labelText: 'Exercise'),
                items: [
                  for (final item in overview.exerciseHistories)
                    DropdownMenuItem(
                      value: item.exerciseId,
                      child: Text(item.optionLabel),
                    ),
                ],
                onChanged: onExerciseChanged,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(history.dayLabel, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.lg,
          children: [
            SizedBox(
              width: 320,
              child: _ProgressMetricCard(
                title: history.type == ExerciseType.strength
                    ? 'Last used reference'
                    : 'Logged cardio minutes',
                value: history.type == ExerciseType.strength
                    ? (history.lastUsedWeight == null
                        ? 'None yet'
                        : '${_formatDouble(history.lastUsedWeight!)} ${overview.weightUnit.name}')
                    : '${history.totalCardioMinutes}',
                subtitle: history.type == ExerciseType.strength
                    ? 'Real completed weight only. Never auto-filled into sessions.'
                    : 'Total logged duration inside the selected range.',
              ),
            ),
            SizedBox(
              width: 320,
              child: _ProgressMetricCard(
                title: history.type == ExerciseType.strength
                    ? 'Completed sets'
                    : 'Logged entries',
                value: history.type == ExerciseType.strength
                    ? '${history.completedStrengthSets}'
                    : '${history.series.length}',
                subtitle: '${_rangeLabel(overview.range)} of real history.',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        if (!history.hasHistory)
          AppEmptyState(
            title: history.type == ExerciseType.strength
                ? 'No strength history yet'
                : 'No cardio history yet',
            description: history.type == ExerciseType.strength
                ? 'Complete some weighted sets for this exercise to see trend data.'
                : 'Log some cardio blocks for this exercise to see duration trends.',
          )
        else
          ProgressChartCard(
            title: history.type == ExerciseType.strength
                ? '${history.displayName} progress'
                : '${history.displayName} cardio volume',
            subtitle: history.type == ExerciseType.strength
                ? 'Best completed weight per day · ${_rangeLabel(overview.range)}'
                : 'Logged duration per day · ${_rangeLabel(overview.range)}',
            bars: [
              for (final point in history.series)
                ProgressChartBar(label: point.label, value: point.value),
            ],
          ),
      ],
    );
  }
}

class _OverallProgressView extends StatelessWidget {
  const _OverallProgressView({required this.overview});

  final ProgressOverview overview;

  @override
  Widget build(BuildContext context) {
    if (!overview.hasAnyHistory) {
      return const AppEmptyState(
        title: 'No progress history yet',
        description: 'Complete some real sessions and logs first. Progress only reflects executed data, never planned templates.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.lg,
          children: [
            SizedBox(
              width: 280,
              child: _ProgressMetricCard(
                title: 'Completed sessions',
                value: '${overview.completedSessionCount}',
                subtitle: _rangeLabel(overview.range),
              ),
            ),
            SizedBox(
              width: 280,
              child: _ProgressMetricCard(
                title: 'Completed strength sets',
                value: '${overview.completedStrengthSetCount}',
                subtitle: 'Completed set logs inside the selected range.',
              ),
            ),
            SizedBox(
              width: 280,
              child: _ProgressMetricCard(
                title: 'Cardio minutes',
                value: '${overview.totalCardioMinutes}',
                subtitle: 'Manual cardio logs inside the selected range.',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        if (overview.overallCompletedSessionSeries.isEmpty)
          const AppEmptyState(
            title: 'No completed sessions in range',
            description: 'Mark sessions as completed to populate the overall completion chart.',
          )
        else
          ProgressChartCard(
            title: 'Weekly completion',
            subtitle: 'Completed sessions per week',
            bars: [
              for (final point in overview.overallCompletedSessionSeries)
                ProgressChartBar(label: point.label, value: point.value),
            ],
          ),
        const SizedBox(height: AppSpacing.xl),
        if (overview.overallCardioMinuteSeries.isEmpty)
          const AppEmptyState(
            title: 'No cardio in range',
            description: 'Once cardio blocks are logged, SmartFit will chart weekly duration here.',
          )
        else
          ProgressChartCard(
            title: 'Weekly cardio volume',
            subtitle: 'Total cardio minutes per week',
            bars: [
              for (final point in overview.overallCardioMinuteSeries)
                ProgressChartBar(label: point.label, value: point.value),
            ],
          ),
      ],
    );
  }
}

class _ProgressMetricCard extends StatelessWidget {
  const _ProgressMetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
  });

  final String title;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppInteractiveSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: theme.textTheme.displaySmall),
          const SizedBox(height: AppSpacing.xs),
          Text(subtitle, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

String _rangeLabel(ProgressRange range) {
  return switch (range) {
    ProgressRange.last30Days => 'Last 30 days',
    ProgressRange.last8Weeks => 'Last 8 weeks',
    ProgressRange.allTime => 'All time',
  };
}

String _formatDouble(double value) {
  return value.toStringAsFixed(value % 1 == 0 ? 0 : 1);
}