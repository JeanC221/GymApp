import 'package:smartfit/core/domain/entities/app_settings.dart';
import 'package:smartfit/core/domain/entities/cardio_template.dart';
import 'package:smartfit/core/domain/entities/exercise_template.dart';
import 'package:smartfit/core/domain/entities/plan_day.dart';
import 'package:smartfit/core/domain/entities/strength_set_log.dart';
import 'package:smartfit/core/domain/entities/strength_template.dart';
import 'package:smartfit/core/domain/entities/weekly_plan.dart';
import 'package:smartfit/core/domain/entities/workout_session.dart';
import 'package:smartfit/core/domain/enums/app_theme_preference.dart';
import 'package:smartfit/core/domain/enums/exercise_type.dart';
import 'package:smartfit/core/domain/enums/plan_day_type.dart';
import 'package:smartfit/core/domain/enums/progress_range.dart';
import 'package:smartfit/core/domain/enums/weekday.dart';
import 'package:smartfit/core/domain/enums/weight_unit.dart';
import 'package:smartfit/core/domain/enums/workout_session_status.dart';
import 'package:smartfit/core/domain/repositories/schedule_repository.dart';
import 'package:smartfit/core/domain/repositories/settings_repository.dart';
import 'package:smartfit/core/domain/repositories/workout_repository.dart';

class SmartFitDevSeed {
  SmartFitDevSeed({
    required ScheduleRepository scheduleRepository,
    required WorkoutRepository workoutRepository,
    required SettingsRepository settingsRepository,
  }) : _scheduleRepository = scheduleRepository,
       _workoutRepository = workoutRepository,
       _settingsRepository = settingsRepository;

  final ScheduleRepository _scheduleRepository;
  final WorkoutRepository _workoutRepository;
  final SettingsRepository _settingsRepository;

  Future<void> seedIfEmpty() async {
    final activePlan = await _scheduleRepository.getActivePlan();
    if (activePlan != null) {
      return;
    }

    final now = DateTime.now();

    await _settingsRepository.saveSettings(
      AppSettings(
        id: 'app_settings',
        themeMode: AppThemePreference.system,
        weightUnit: WeightUnit.kg,
        firstLaunchCompleted: true,
        lastBackupAt: null,
        preferredGraphRange: ProgressRange.last30Days,
      ),
    );

    await _scheduleRepository.saveWeeklyPlan(
      WeeklyPlan(
        id: 'weekly_plan_default',
        createdAt: now,
        updatedAt: now,
        isActive: true,
      ),
    );

    await _scheduleRepository.savePlanDay(
      PlanDay(
        id: 'plan_day_push',
        weeklyPlanId: 'weekly_plan_default',
        weekday: Weekday.monday,
        type: PlanDayType.training,
        routineName: 'Push',
        orderIndex: 0,
      ),
    );

    await _scheduleRepository.savePlanDay(
      PlanDay(
        id: 'plan_day_cardio',
        weeklyPlanId: 'weekly_plan_default',
        weekday: Weekday.wednesday,
        type: PlanDayType.training,
        routineName: 'Cardio',
        orderIndex: 1,
      ),
    );

    await _scheduleRepository.saveStrengthExercise(
      exercise: ExerciseTemplate(
        id: 'exercise_bench_press',
        planDayId: 'plan_day_push',
        type: ExerciseType.strength,
        orderIndex: 0,
        displayName: 'Bench Press',
      ),
      template: StrengthTemplate(
        exerciseTemplateId: 'exercise_bench_press',
        targetSets: 3,
        targetReps: 8,
      ),
    );

    await _scheduleRepository.saveCardioExercise(
      exercise: ExerciseTemplate(
        id: 'exercise_treadmill',
        planDayId: 'plan_day_cardio',
        type: ExerciseType.cardio,
        orderIndex: 0,
        displayName: 'Treadmill',
      ),
      template: CardioTemplate(
        exerciseTemplateId: 'exercise_treadmill',
        cardioType: 'Treadmill',
        defaultDurationMinutes: 20,
        defaultIncline: 4,
      ),
    );

    await _workoutRepository.saveWorkoutSession(
      WorkoutSession(
        id: 'session_push_1',
        planDayId: 'plan_day_push',
        sessionDate: now.subtract(const Duration(days: 2)),
        sessionStatus: WorkoutSessionStatus.completed,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
    );

    await _workoutRepository.saveStrengthSetLogs([
      StrengthSetLog(
        id: 'bench_log_1',
        workoutSessionId: 'session_push_1',
        exerciseTemplateId: 'exercise_bench_press',
        setIndex: 0,
        performedReps: 8,
        performedWeight: 60,
        isCompleted: true,
        completedAt: now.subtract(const Duration(days: 2)),
      ),
      StrengthSetLog(
        id: 'bench_log_2',
        workoutSessionId: 'session_push_1',
        exerciseTemplateId: 'exercise_bench_press',
        setIndex: 1,
        performedReps: 8,
        performedWeight: 62.5,
        isCompleted: true,
        completedAt: now.subtract(const Duration(days: 2)),
      ),
    ]);
  }
}