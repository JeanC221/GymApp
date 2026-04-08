import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartfit/app/bootstrap/app_bootstrap.dart';
import 'package:smartfit/core/domain/entities/cardio_template.dart';
import 'package:smartfit/core/domain/entities/exercise_template.dart';
import 'package:smartfit/core/domain/entities/plan_day.dart';
import 'package:smartfit/core/domain/entities/strength_template.dart';
import 'package:smartfit/core/domain/enums/exercise_type.dart';
import 'package:smartfit/core/domain/enums/weekday.dart';
import 'package:smartfit/features/week/presentation/controllers/week_controller.dart';

final todayOverviewProvider = FutureProvider<TodayOverview>((ref) async {
  ref.watch(weekRefreshTickProvider);
  ref.watch(workoutRefreshTickProvider);

  final bootstrap = await ref.watch(appBootstrapProvider.future);
  final scheduleRepository = bootstrap.scheduleRepository;
  final workoutRepository = bootstrap.workoutRepository;
  final now = DateTime.now();
  final todayWeekday = Weekday.values[now.weekday - 1];

  final day = await scheduleRepository.getPlanDayForDate(now);
  if (day == null) {
    return TodayOverview(
      currentWeekday: todayWeekday,
      day: null,
      exercises: const [],
    );
  }

  final exercises = await scheduleRepository.listExercises(day.id);
  final items = <TodayExerciseOverview>[];

  for (final exercise in exercises) {
    if (exercise.type == ExerciseType.strength) {
      final template = await scheduleRepository.getStrengthTemplate(exercise.id);
      if (template != null) {
        final lastUsed = await workoutRepository.getLastUsedWeight(exercise.id);
        items.add(
          TodayExerciseOverview.strength(
            exercise: exercise,
            template: template,
            lastUsedWeight: lastUsed?.performedWeight,
          ),
        );
      }
      continue;
    }

    final template = await scheduleRepository.getCardioTemplate(exercise.id);
    if (template != null) {
      items.add(
        TodayExerciseOverview.cardio(
          exercise: exercise,
          template: template,
        ),
      );
    }
  }

  return TodayOverview(
    currentWeekday: todayWeekday,
    day: day,
    exercises: items,
  );
});

class TodayOverview {
  const TodayOverview({
    required this.currentWeekday,
    required this.day,
    required this.exercises,
  });

  final Weekday currentWeekday;
  final PlanDay? day;
  final List<TodayExerciseOverview> exercises;

  bool get hasPlanForToday => day != null;
  bool get isRestDay => day?.isRestDay ?? false;
  bool get isTrainingDay => day?.isTrainingDay ?? false;

  String get todaySummary {
    if (day == null) {
      return 'No created day for ${currentWeekday.displayName}.';
    }

    if (day!.isRestDay) {
      return 'Recovery, mobility and steps only.';
    }

    final strengthCount = exercises.where((item) => item.type == ExerciseType.strength).length;
    final cardioCount = exercises.where((item) => item.type == ExerciseType.cardio).length;
    return '$strengthCount strength, $cardioCount cardio';
  }
}

class TodayExerciseOverview {
  const TodayExerciseOverview._({
    required this.exercise,
    required this.type,
    this.strengthTemplate,
    this.cardioTemplate,
    this.lastUsedWeight,
  });

  factory TodayExerciseOverview.strength({
    required ExerciseTemplate exercise,
    required StrengthTemplate template,
    double? lastUsedWeight,
  }) {
    return TodayExerciseOverview._(
      exercise: exercise,
      type: ExerciseType.strength,
      strengthTemplate: template,
      lastUsedWeight: lastUsedWeight,
    );
  }

  factory TodayExerciseOverview.cardio({
    required ExerciseTemplate exercise,
    required CardioTemplate template,
  }) {
    return TodayExerciseOverview._(
      exercise: exercise,
      type: ExerciseType.cardio,
      cardioTemplate: template,
    );
  }

  final ExerciseTemplate exercise;
  final ExerciseType type;
  final StrengthTemplate? strengthTemplate;
  final CardioTemplate? cardioTemplate;
  final double? lastUsedWeight;
}