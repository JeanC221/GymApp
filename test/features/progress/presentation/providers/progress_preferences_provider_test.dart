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
import 'package:smartfit/core/domain/enums/progress_range.dart';
import 'package:smartfit/core/domain/enums/weekday.dart';
import 'package:smartfit/core/domain/enums/weight_unit.dart';
import 'package:smartfit/core/domain/repositories/schedule_repository.dart';
import 'package:smartfit/core/domain/repositories/settings_repository.dart';
import 'package:smartfit/core/domain/repositories/workout_repository.dart';
import 'package:smartfit/features/progress/presentation/providers/progress_preferences_provider.dart';

void main() {
  test('saves and rehydrates preferred progress range', () async {
    final settingsRepository = _MemorySettingsRepository(
      const AppSettings(
        id: 'settings',
        themeMode: AppThemePreference.system,
        weightUnit: WeightUnit.kg,
        firstLaunchCompleted: true,
        lastBackupAt: null,
        preferredGraphRange: ProgressRange.last30Days,
      ),
    );

    final container = ProviderContainer(
      overrides: [
        appBootstrapProvider.overrideWith(
          (ref) async => AppBootstrap(
            scheduleRepository: _NoopScheduleRepository(),
            workoutRepository: _NoopWorkoutRepository(),
            settingsRepository: settingsRepository,
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(
      await container.read(preferredProgressRangeProvider.future),
      ProgressRange.last30Days,
    );

    await container
        .read(progressPreferencesControllerProvider)
        .savePreferredRange(ProgressRange.allTime);

    expect(settingsRepository.current.preferredGraphRange, ProgressRange.allTime);
    expect(
      await container.read(preferredProgressRangeProvider.future),
      ProgressRange.allTime,
    );
  });
}

class _MemorySettingsRepository implements SettingsRepository {
  _MemorySettingsRepository(this.current);

  AppSettings current;

  @override
  Future<AppSettings?> getSettings() async => current;

  @override
  Future<void> saveSettings(AppSettings settings) async {
    current = settings;
  }
}

class _NoopScheduleRepository implements ScheduleRepository {
  @override
  Future<void> deleteExercise(String exerciseTemplateId) async {}

  @override
  Future<void> deletePlanDay(String planDayId) async {}

  @override
  Future<WeeklyPlan?> getActivePlan() async => null;

  @override
  Future<CardioTemplate?> getCardioTemplate(String exerciseTemplateId) async => null;

  @override
  Future<PlanDay?> getPlanDayByWeekday(String weeklyPlanId, Weekday weekday) async => null;

  @override
  Future<PlanDay?> getPlanDayForDate(DateTime date) async => null;

  @override
  Future<StrengthTemplate?> getStrengthTemplate(String exerciseTemplateId) async => null;

  @override
  Future<List<PlanDay>> listCreatedDays(String weeklyPlanId) async => const [];

  @override
  Future<List<ExerciseTemplate>> listExercises(String planDayId) async => const [];

  @override
  Future<List<PlanDay>> listPlanDays(String weeklyPlanId) async => const [];

  @override
  Future<void> reorderExercises(
    String planDayId,
    List<ExerciseTemplate> orderedExercises,
  ) async {}

  @override
  Future<void> reorderPlanDays(List<PlanDay> orderedDays) async {}

  @override
  Future<void> saveCardioExercise({
    required ExerciseTemplate exercise,
    required CardioTemplate template,
  }) async {}

  @override
  Future<void> savePlanDay(PlanDay day) async {}

  @override
  Future<void> saveStrengthExercise({
    required ExerciseTemplate exercise,
    required StrengthTemplate template,
  }) async {}

  @override
  Future<void> saveWeeklyPlan(WeeklyPlan plan) async {}
}

class _NoopWorkoutRepository implements WorkoutRepository {
  @override
  Future<void> deleteCardioLogsForSession(String workoutSessionId) async {}

  @override
  Future<void> deleteStrengthLogsForSession(String workoutSessionId) async {}

  @override
  Future<void> deleteWorkoutSession(String sessionId) async {}

  @override
  Future<StrengthSetLog?> getLastUsedWeight(String exerciseTemplateId) async => null;

  @override
  Future<List<CardioLog>> listCardioLogs(String workoutSessionId) async => const [];

  @override
  Future<List<WorkoutSession>> listSessionsForPlanDay(String planDayId) async => const [];

  @override
  Future<List<StrengthSetLog>> listStrengthSetLogs(String workoutSessionId) async => const [];

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