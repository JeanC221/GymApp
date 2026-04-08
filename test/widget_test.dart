import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smartfit/app/bootstrap/app_bootstrap.dart';
import 'package:smartfit/app/smartfit_app.dart';
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
import 'package:smartfit/core/domain/repositories/schedule_repository.dart';
import 'package:smartfit/core/domain/repositories/settings_repository.dart';
import 'package:smartfit/core/domain/repositories/workout_repository.dart';

void main() {
  testWidgets('SmartFit shell renders', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appBootstrapProvider.overrideWith(
            (ref) async => AppBootstrap(
              scheduleRepository: _FakeScheduleRepository(),
              workoutRepository: _FakeWorkoutRepository(),
              settingsRepository: _FakeSettingsRepository(),
            ),
          ),
        ],
        child: const SmartFitApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('SmartFit'), findsWidgets);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Week'), findsOneWidget);
    expect(find.text('Progress'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('SmartFit applies the persisted theme mode', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appBootstrapProvider.overrideWith(
            (ref) async => AppBootstrap(
              scheduleRepository: _FakeScheduleRepository(),
              workoutRepository: _FakeWorkoutRepository(),
              settingsRepository: _FakeSettingsRepository(
                const AppSettings(
                  id: 'settings',
                  themeMode: AppThemePreference.dark,
                  weightUnit: WeightUnit.kg,
                  firstLaunchCompleted: true,
                  lastBackupAt: null,
                  preferredGraphRange: ProgressRange.last30Days,
                ),
              ),
            ),
          ),
        ],
        child: const SmartFitApp(),
      ),
    );
    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);
  });
}

class _FakeScheduleRepository implements ScheduleRepository {
  final WeeklyPlan _plan = WeeklyPlan(
    id: 'test_plan',
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
    isActive: true,
  );

  final PlanDay _day = PlanDay(
    id: 'test_day',
    weeklyPlanId: 'test_plan',
    weekday: Weekday.monday,
    type: PlanDayType.training,
    routineName: 'Push',
    orderIndex: 0,
  );

  @override
  Future<WeeklyPlan?> getActivePlan() async => _plan;

  @override
  Future<PlanDay?> getPlanDayByWeekday(String weeklyPlanId, Weekday weekday) async {
    return _day;
  }

  @override
  Future<PlanDay?> getPlanDayForDate(DateTime date) async => _day;

  @override
  Future<CardioTemplate?> getCardioTemplate(String exerciseTemplateId) async => null;

  @override
  Future<StrengthTemplate?> getStrengthTemplate(String exerciseTemplateId) async {
    return StrengthTemplate(
      exerciseTemplateId: exerciseTemplateId,
      targetSets: 3,
      targetReps: 8,
    );
  }

  @override
  Future<List<PlanDay>> listCreatedDays(String weeklyPlanId) async => [_day];

  @override
  Future<List<ExerciseTemplate>> listExercises(String planDayId) async {
    return [
      ExerciseTemplate(
        id: 'exercise_1',
        planDayId: planDayId,
        type: ExerciseType.strength,
        orderIndex: 0,
        displayName: 'Bench Press',
      ),
    ];
  }

  @override
  Future<List<PlanDay>> listPlanDays(String weeklyPlanId) async => [_day];

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

class _FakeWorkoutRepository implements WorkoutRepository {
  @override
  Future<void> deleteCardioLogsForSession(String workoutSessionId) async {}

  @override
  Future<void> deleteStrengthLogsForSession(String workoutSessionId) async {}

  @override
  Future<void> deleteWorkoutSession(String sessionId) async {}

  @override
  Future<StrengthSetLog?> getLastUsedWeight(String exerciseTemplateId) async {
    return StrengthSetLog(
      id: 'log_1',
      workoutSessionId: 'session_1',
      exerciseTemplateId: exerciseTemplateId,
      setIndex: 0,
      performedReps: 8,
      performedWeight: 60,
      isCompleted: true,
      completedAt: DateTime(2026),
    );
  }

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
  Future<WorkoutSession?> getSessionForPlanDayAndDate({required String planDayId, required DateTime sessionDate}) async {
    return null;
  }
}

class _FakeSettingsRepository implements SettingsRepository {
  _FakeSettingsRepository([
    this._settings = const AppSettings(
      id: 'settings',
      themeMode: AppThemePreference.system,
      weightUnit: WeightUnit.kg,
      firstLaunchCompleted: true,
      lastBackupAt: null,
      preferredGraphRange: ProgressRange.last30Days,
    ),
  ]);

  AppSettings _settings;

  @override
  Future<AppSettings?> getSettings() async => _settings;

  @override
  Future<void> saveSettings(AppSettings settings) async {
    _settings = settings;
  }
}
