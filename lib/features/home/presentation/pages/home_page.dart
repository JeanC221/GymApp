import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartfit/app/theme/tokens/app_spacing.dart';
import 'package:smartfit/core/constants/app_constants.dart';
import 'package:smartfit/features/day_detail/presentation/pages/day_detail_page.dart';
import 'package:smartfit/features/home/presentation/providers/today_overview_provider.dart';
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

    return AppPageScaffold(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppConstants.appName, style: theme.textTheme.displaySmall),
          const SizedBox(height: AppSpacing.sm),
          Text('Today', style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'A realistic shell for the current day, built with the Phase 3 component library before real feature wiring begins.',
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
        data: (today) => ListView(
          children: [
            Row(
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
            ),
            const SizedBox(height: AppSpacing.xl),
            if (!today.hasPlanForToday)
              AppEmptyState(
                title: 'No plan for ${today.currentWeekday.displayName}',
                description: 'Only created days appear in SmartFit. Add a training or rest day from Week to make today show up here.',
                buttonLabel: 'Go to week',
                onPressed: () => context.go(WeekPage.routePath),
              )
            else if (today.isRestDay) ...[
              RestDayCard(
                weekdayLabel: today.day!.weekday.displayName,
                message: today.todaySummary,
                onTap: () => context.go(DayDetailPage.buildPath(today.day!.id)),
              ),
            ] else ...[
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
          ],
        ),
      ),
    );
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
