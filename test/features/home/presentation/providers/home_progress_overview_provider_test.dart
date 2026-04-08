import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartfit/app/bootstrap/app_bootstrap.dart';
import 'package:smartfit/core/domain/entities/app_settings.dart';
import 'package:smartfit/core/domain/entities/cardio_log.dart';
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
import 'package:smartfit/features/home/presentation/providers/home_progress_overview_provider.dart';

void main() {
  test('uses preferred range from settings for home progress snapshot', () async {
    final now = DateTime.now();
    final scheduleRepository = _MemoryScheduleRepository(
      planDay: PlanDay(
        id: 'day_1',
        weeklyPlanId: 'plan_1',
        weekday: Weekday.monday,
        type: PlanDayType.training,
        routineName: 'Push',
        orderIndex: 0,
      ),
      exercises: [
        ExerciseTemplate(
          id: 'exercise_strength',
          planDayId: 'day_1',
          type: ExerciseType.strength,
          orderIndex: 0,
          displayName: 'Bench Press',
        ),
      ],
    );
    final workoutRepository = _MemoryWorkoutRepository(
      sessions: [
        WorkoutSession(
          id: 'session_recent',
          planDayId: 'day_1',
          sessionDate: DateTime(now.year, now.month, now.day).subtract(const Duration(days: 45)),
          sessionStatus: WorkoutSessionStatus.completed,
          createdAt: now,
          updatedAt: now,
        ),
      ],
      strengthLogsBySession: {
        'session_recent': [
          StrengthSetLog(
            id: 'log_1',
            workoutSessionId: 'session_recent',
            exerciseTemplateId: 'exercise_strength',
            setIndex: 0,
            performedReps: 8,
            performedWeight: 70,
            isCompleted: true,
            completedAt: DateTime(now.year, now.month, now.day),
          ),
        ],
      },
    );
    final settingsRepository = _MemorySettingsRepository(
      const AppSettings(
        id: 'settings',
        themeMode: AppThemePreference.system,
        weightUnit: WeightUnit.kg,
        firstLaunchCompleted: true,
        lastBackupAt: null,
        preferredGraphRange: ProgressRange.last8Weeks,
      ),
    );

    final container = ProviderContainer(
      overrides: [
        appBootstrapProvider.overrideWith(
          (ref) async => AppBootstrap(
            scheduleRepository: scheduleRepository,
            workoutRepository: workoutRepository,
            settingsRepository: settingsRepository,
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    final overview = await container.read(homeProgressOverviewProvider.future);

    expect(overview.range, ProgressRange.last8Weeks);
    expect(overview.completedSessionCount, 1);
    expect(overview.defaultExerciseHistory?.lastUsedWeight, 70);
  });
}

class _MemoryScheduleRepository implements ScheduleRepository {
  _MemoryScheduleRepository({
    required this.planDay,
    required this.exercises,
  });

  final PlanDay planDay;
  final List<ExerciseTemplate> exercises;

  @override
  Future<WeeklyPlan?> getActivePlan() async {
    return WeeklyPlan(
      id: 'plan_1',
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
      isActive: true,
    );
  }

  @override
  Future<CardioTemplate?> getCardioTemplate(String exerciseTemplateId) async => null;

  @override
  Future<PlanDay?> getPlanDayByWeekday(String weeklyPlanId, Weekday weekday) async {
    return planDay.weekday == weekday ? planDay : null;
  }

  @override
  Future<PlanDay?> getPlanDayForDate(DateTime date) async {
    return planDay;
  }

  @override
  Future<StrengthTemplate?> getStrengthTemplate(String exerciseTemplateId) async {
    return StrengthTemplate(
      exerciseTemplateId: exerciseTemplateId,
      targetSets: 4,
      targetReps: 8,
    );
  }

  @override
  Future<List<PlanDay>> listCreatedDays(String weeklyPlanId) async => [planDay];

  @override
  Future<List<ExerciseTemplate>> listExercises(String planDayId) async => exercises;

  @override
  Future<List<PlanDay>> listPlanDays(String weeklyPlanId) async => [planDay];

  @override
  Future<void> deleteExercise(String exerciseTemplateId) async {}

  @override
  Future<void> deletePlanDay(String planDayId) async {}

  @override
  Future<void> reorderExercises(String planDayId, List<ExerciseTemplate> orderedExercises) async {}

  @override
  Future<void> reorderPlanDays(List<PlanDay> orderedDays) async {}

  @override
  Future<void> saveCardioExercise({required ExerciseTemplate exercise, required CardioTemplate template}) async {}

  @override
  Future<void> savePlanDay(PlanDay day) async {}

  @override
  Future<void> saveStrengthExercise({required ExerciseTemplate exercise, required StrengthTemplate template}) async {}

  @override
  Future<void> saveWeeklyPlan(WeeklyPlan plan) async {}
}

class _MemoryWorkoutRepository implements WorkoutRepository {
  _MemoryWorkoutRepository({
    required this.sessions,
    required this.strengthLogsBySession,
  });

  final List<WorkoutSession> sessions;
  final Map<String, List<StrengthSetLog>> strengthLogsBySession;

  @override
  Future<void> deleteCardioLogsForSession(String workoutSessionId) async {}

  @override
  Future<void> deleteStrengthLogsForSession(String workoutSessionId) async {}

  @override
  Future<void> deleteWorkoutSession(String sessionId) async {}

  @override
  Future<StrengthSetLog?> getLastUsedWeight(String exerciseTemplateId) async {
    final logs = strengthLogsBySession.values.expand((item) => item);
    for (final log in logs) {
      if (log.exerciseTemplateId == exerciseTemplateId && log.isCompleted) {
        return log;
      }
    }
    return null;
  }

  @override
  Future<List<CardioLog>> listCardioLogs(String workoutSessionId) async => const [];

  @override
  Future<List<WorkoutSession>> listSessionsForPlanDay(String planDayId) async {
    return sessions.where((item) => item.planDayId == planDayId).toList(growable: false);
  }

  @override
  Future<List<StrengthSetLog>> listStrengthSetLogs(String workoutSessionId) async {
    return [...?strengthLogsBySession[workoutSessionId]];
  }

  @override
  Future<void> saveCardioLog(CardioLog log) async {}

  @override
  Future<void> saveCardioLogs(List<CardioLog> logs) async {}

  @override
  Future<void> saveStrengthSetLog(StrengthSetLog log) async {}

  @override
  Future<void> saveStrengthSetLogs(List<StrengthSetLog> logs) async {}

  @override
  Future<void> saveWorkoutSession(WorkoutSession session) async {}

  @override
  Future<WorkoutSession?> getSessionForPlanDayAndDate({required String planDayId, required DateTime sessionDate}) async => null;
}

class _MemorySettingsRepository implements SettingsRepository {
  _MemorySettingsRepository(this.settings);

  final AppSettings settings;

  @override
  Future<AppSettings?> getSettings() async => settings;

  @override
  Future<void> saveSettings(AppSettings settings) async {}
}