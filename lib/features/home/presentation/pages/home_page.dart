import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartfit/app/theme/tokens/app_breakpoints.dart';
import 'package:smartfit/app/theme/tokens/app_spacing.dart';
import 'package:smartfit/core/constants/app_constants.dart';
import 'package:smartfit/core/domain/enums/exercise_type.dart';
import 'package:smartfit/features/day_detail/presentation/pages/day_detail_page.dart';
import 'package:smartfit/features/home/presentation/providers/home_progress_overview_provider.dart';
import 'package:smartfit/features/home/presentation/providers/today_overview_provider.dart';
import 'package:smartfit/features/progress/presentation/providers/progress_overview_provider.dart';
import 'package:smartfit/features/progress/presentation/pages/progress_page.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_empty_state.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_error_state.dart';
import 'package:smartfit/features/shared/presentation/layouts/app_page_scaffold.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_icon_capsule_button.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_primary_button.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_secondary_button.dart';
import 'package:smartfit/features/shared/presentation/widgets/cardio_exercise_card.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_interactive_surface.dart';
import 'package:smartfit/features/shared/presentation/widgets/rest_day_card.dart';
import 'package:smartfit/features/shared/presentation/widgets/strength_exercise_card.dart';
import 'package:smartfit/features/shared/presentation/widgets/training_day_card.dart';
import 'package:smartfit/features/week/presentation/pages/week_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const routeName = 'home';
  static const routePath = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final todayAsync = ref.watch(todayOverviewProvider);
    final progressAsync = ref.watch(homeProgressOverviewProvider);

    return AppPageScaffold(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppConstants.appName, style: theme.textTheme.displaySmall),
          const SizedBox(height: AppSpacing.sm),
          Text('Today', style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Today stays focused on the active plan, but it now pulls a real progress snapshot from your completed history too.',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
      actions: [
        AppIconCapsuleButton(
          icon: Icons.play_arrow_rounded,
          label: 'Quick start',
          onPressed: () => context.go(WeekPage.routePath),
        ),
      ],
      child: todayAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => AppErrorState(
          title: 'Could not load today',
          description: error.toString(),
          onRetry: () => ref.invalidate(todayOverviewProvider),
        ),
        data: (today) => HomePageContent(
          today: today,
          progressAsync: progressAsync,
        ),
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({
    required this.today,
    required this.progressAsync,
    super.key,
  });

  final TodayOverview today;
  final AsyncValue<ProgressOverview> progressAsync;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= AppBreakpoints.medium;
        final primarySections = _buildPrimarySections(context);

        if (!isTablet) {
          return ListView(
            children: [
              ...primarySections,
              const SizedBox(height: AppSpacing.xl),
              _HomeProgressSection(progressAsync: progressAsync),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                primary: false,
                children: primarySections,
              ),
            ),
            const SizedBox(width: AppSpacing.xl),
            SizedBox(
              width: 360,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TodayInspectorPanel(today: today),
                  const SizedBox(height: AppSpacing.xl),
                  _HomeProgressSection(progressAsync: progressAsync),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildPrimarySections(BuildContext context) {
    return [
      LayoutBuilder(
        builder: (context, constraints) {
          final shouldStack = constraints.maxWidth < AppBreakpoints.compact;
          if (shouldStack) {
            return Column(
              children: [
                AppPrimaryButton(
                  label: today.hasPlanForToday ? 'Open today detail' : 'Create first day',
                  icon: today.hasPlanForToday
                      ? Icons.play_arrow_rounded
                      : Icons.calendar_view_week_rounded,
                  onPressed: () => today.hasPlanForToday
                      ? context.go(DayDetailPage.buildPath(today.day!.id))
                      : context.go(WeekPage.routePath),
                ),
                const SizedBox(height: AppSpacing.md),
                AppSecondaryButton(
                  label: 'Manage week',
                  icon: Icons.edit_calendar_outlined,
                  onPressed: () => context.go(WeekPage.routePath),
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: AppPrimaryButton(
                  label: today.hasPlanForToday ? 'Open today detail' : 'Create first day',
                  icon: today.hasPlanForToday
                      ? Icons.play_arrow_rounded
                      : Icons.calendar_view_week_rounded,
                  onPressed: () => today.hasPlanForToday
                      ? context.go(DayDetailPage.buildPath(today.day!.id))
                      : context.go(WeekPage.routePath),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppSecondaryButton(
                  label: 'Manage week',
                  icon: Icons.edit_calendar_outlined,
                  onPressed: () => context.go(WeekPage.routePath),
                ),
              ),
            ],
          );
        },
      ),
      const SizedBox(height: AppSpacing.xl),
      if (!today.hasPlanForToday)
        AppEmptyState(
          title: 'No plan for ${today.currentWeekday.displayName}',
          description: 'Only created days appear in SmartFit. Add a training or rest day from Week to make today show up here.',
          buttonLabel: 'Go to week',
          onPressed: () => context.go(WeekPage.routePath),
        )
      else if (today.isRestDay)
        RestDayCard(
          weekdayLabel: today.day!.weekday.displayName,
          message: today.todaySummary,
          onTap: () => context.go(DayDetailPage.buildPath(today.day!.id)),
        )
      else ...[
        TrainingDayCard(
          weekdayLabel: today.day!.weekday.displayName,
          routineName: today.day!.routineName ?? 'Training day',
          exerciseSummary: today.todaySummary,
          onTap: () => context.go(DayDetailPage.buildPath(today.day!.id)),
        ),
        const SizedBox(height: AppSpacing.xl),
        Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.lg,
          children: [
            SizedBox(
              width: 320,
              child: _MetricCard(
                title: 'Planned blocks',
                value: '${today.exercises.length}',
                subtitle: today.todaySummary,
              ),
            ),
            SizedBox(
              width: 320,
              child: _MetricCard(
                title: 'Day type',
                value: 'Training',
                subtitle: today.day!.weekday.displayName,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        for (final item in today.exercises) ...[
          if (item.type.name == 'strength')
            StrengthExerciseCard(
              name: item.exercise.displayName,
              targetSummary:
                  '${item.strengthTemplate!.targetSets} sets x ${item.strengthTemplate!.targetReps} reps',
              lastWeightSummary: item.lastUsedWeight == null
                  ? 'Last used: none yet'
                  : 'Last used: ${item.lastUsedWeight!.toStringAsFixed(item.lastUsedWeight! % 1 == 0 ? 0 : 1)} kg',
              onTap: () => context.go(DayDetailPage.buildPath(today.day!.id)),
            )
          else
            CardioExerciseCard(
              name: item.exercise.displayName,
              durationSummary: item.cardioTemplate!.defaultDurationMinutes == null
                  ? 'Manual cardio block'
                  : '${item.cardioTemplate!.defaultDurationMinutes} min block',
              detailSummary: item.cardioTemplate!.defaultIncline == null
                  ? item.cardioTemplate!.cardioType
                  : '${item.cardioTemplate!.cardioType}, incline ${item.cardioTemplate!.defaultIncline}',
              onTap: () => context.go(DayDetailPage.buildPath(today.day!.id)),
            ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ],
    ];
  }
}

class _TodayInspectorPanel extends StatelessWidget {
  const _TodayInspectorPanel({required this.today});

  final TodayOverview today;

  @override
  Widget build(BuildContext context) {
    final summaryTitle = !today.hasPlanForToday
        ? 'Today is still empty'
        : today.isRestDay
            ? 'Rest day locked in'
            : today.day!.routineName ?? 'Training day';

    return AppInteractiveSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Day inspector', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(summaryTitle, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            today.hasPlanForToday
                ? today.todaySummary
                : 'Add a created day from the weekly planner to make this panel actionable.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              _InspectorChip(label: today.currentWeekday.displayName),
              _InspectorChip(
                label: !today.hasPlanForToday
                    ? 'No plan'
                    : today.isRestDay
                        ? 'Rest'
                        : 'Training',
              ),
              _InspectorChip(label: '${today.exercises.length} planned blocks'),
            ],
          ),
        ],
      ),
    );
  }
}

class _InspectorChip extends StatelessWidget {
  const _InspectorChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label));
  }
}

class _HomeProgressSection extends StatelessWidget {
  const _HomeProgressSection({required this.progressAsync});

  final AsyncValue<ProgressOverview> progressAsync;

  @override
  Widget build(BuildContext context) {
    return progressAsync.when(
      loading: () => AppInteractiveSurface(
        child: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'Loading progress snapshot...',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
      error: (error, stackTrace) => AppInteractiveSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Progress snapshot unavailable', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              error.toString().replaceFirst('Bad state: ', ''),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      data: (overview) {
        final highlightedExercise = overview.defaultExerciseHistory;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Progress snapshot',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                AppSecondaryButton(
                  label: 'Open progress',
                  icon: Icons.show_chart_rounded,
                  onPressed: () => context.go(ProgressPage.routePath),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.lg,
              children: [
                SizedBox(
                  width: 320,
                  child: _MetricCard(
                    title: 'Completed sessions',
                    value: '${overview.completedSessionCount}',
                    subtitle:
                        '${homeProgressRangeLabel(overview.range)} · ${overview.totalCardioMinutes} cardio min',
                  ),
                ),
                SizedBox(
                  width: 320,
                  child: _MetricCard(
                    title: highlightedExercise == null
                        ? 'Tracked history'
                        : (highlightedExercise.type == ExerciseType.strength
                              ? 'Latest lift reference'
                              : 'Tracked cardio block'),
                    value: highlightedExercise == null
                        ? 'No history yet'
                      : _highlightedValue(overview, highlightedExercise),
                    subtitle: highlightedExercise == null
                        ? 'Finish some real sessions to unlock charts and history.'
                        : highlightedExercise.optionLabel,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  String _highlightedValue(
    ProgressOverview overview,
    ProgressExerciseHistory highlightedExercise,
  ) {
    if (highlightedExercise.type == ExerciseType.strength) {
      final lastUsedWeight = highlightedExercise.lastUsedWeight;
      if (lastUsedWeight == null) {
        return 'None yet';
      }
      return '${lastUsedWeight.toStringAsFixed(lastUsedWeight % 1 == 0 ? 0 : 1)} ${overview.weightUnit.name}';
    }

    return '${highlightedExercise.totalCardioMinutes} min';
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
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
