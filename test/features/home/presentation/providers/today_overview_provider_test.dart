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
import 'package:smartfit/core/domain/repositories/schedule_repository.dart';
import 'package:smartfit/core/domain/repositories/settings_repository.dart';
import 'package:smartfit/core/domain/repositories/workout_repository.dart';
import 'package:smartfit/features/home/presentation/providers/today_overview_provider.dart';

void main() {
  group('todayOverviewProvider', () {
    test('returns empty state when there is no created day for today', () async {
      final container = ProviderContainer(
        overrides: [
          appBootstrapProvider.overrideWith(
            (ref) async => AppBootstrap(
              scheduleRepository: _TodayScheduleRepository.empty(),
              workoutRepository: _TodayWorkoutRepository(),
              settingsRepository: _TodaySettingsRepository(),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(todayOverviewProvider.future);

      expect(result.hasPlanForToday, isFalse);
      expect(result.exercises, isEmpty);
      expect(result.todaySummary, contains('No created day'));
    });

    test('returns training summary with strength and cardio items', () async {
      final container = ProviderContainer(
        overrides: [
          appBootstrapProvider.overrideWith(
            (ref) async => AppBootstrap(
              scheduleRepository: _TodayScheduleRepository.trainingToday(),
              workoutRepository: _TodayWorkoutRepository(),
              settingsRepository: _TodaySettingsRepository(),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(todayOverviewProvider.future);

      expect(result.hasPlanForToday, isTrue);
      expect(result.isTrainingDay, isTrue);
      expect(result.exercises, hasLength(2));
      expect(result.todaySummary, '1 strength, 1 cardio');
      expect(result.exercises.first.lastUsedWeight, 62.5);
    });
  });
}

class _TodayScheduleRepository implements ScheduleRepository {
  _TodayScheduleRepository.empty()
      : _planDay = null,
        _exerciseByDay = const {},
        _strengthTemplates = const {},
        _cardioTemplates = const {};

  _TodayScheduleRepository.trainingToday()
      : _planDay = PlanDay(
          id: 'today_day',
          weeklyPlanId: 'plan_1',
          weekday: Weekday.values[DateTime.now().weekday - 1],
          type: PlanDayType.training,
          routineName: 'Upper',
          orderIndex: 0,
        ),
        _exerciseByDay = {
          'today_day': [
            ExerciseTemplate(
              id: 'exercise_strength',
              planDayId: 'today_day',
              type: ExerciseType.strength,
              orderIndex: 0,
              displayName: 'Bench Press',
            ),
            ExerciseTemplate(
              id: 'exercise_cardio',
              planDayId: 'today_day',
              type: ExerciseType.cardio,
              orderIndex: 1,
              displayName: 'Treadmill',
            ),
          ],
        },
        _strengthTemplates = {
          'exercise_strength': StrengthTemplate(
            exerciseTemplateId: 'exercise_strength',
            targetSets: 4,
            targetReps: 8,
          ),
        },
        _cardioTemplates = {
          'exercise_cardio': CardioTemplate(
            exerciseTemplateId: 'exercise_cardio',
            cardioType: 'Treadmill',
            defaultDurationMinutes: 20,
            defaultIncline: 5,
          ),
        };

  final PlanDay? _planDay;
  final Map<String, List<ExerciseTemplate>> _exerciseByDay;
  final Map<String, StrengthTemplate> _strengthTemplates;
  final Map<String, CardioTemplate> _cardioTemplates;

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
  Future<CardioTemplate?> getCardioTemplate(String exerciseTemplateId) async {
    return _cardioTemplates[exerciseTemplateId];
  }

  @override
  Future<PlanDay?> getPlanDayByWeekday(String weeklyPlanId, Weekday weekday) async {
    if (_planDay?.weekday == weekday) {
      return _planDay;
    }
    return null;
  }

  @override
  Future<PlanDay?> getPlanDayForDate(DateTime date) async {
    final weekday = Weekday.values[date.weekday - 1];
    if (_planDay?.weekday == weekday) {
      return _planDay;
    }
    return null;
  }

  @override
  Future<StrengthTemplate?> getStrengthTemplate(String exerciseTemplateId) async {
    return _strengthTemplates[exerciseTemplateId];
  }

  @override
  Future<List<PlanDay>> listCreatedDays(String weeklyPlanId) async {
    return _planDay == null ? [] : [_planDay];
  }

  @override
  Future<List<ExerciseTemplate>> listExercises(String planDayId) async {
    return [...?_exerciseByDay[planDayId]];
  }

  @override
  Future<List<PlanDay>> listPlanDays(String weeklyPlanId) async {
    return _planDay == null ? [] : [_planDay];
  }

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

class _TodayWorkoutRepository implements WorkoutRepository {
  @override
  Future<void> deleteCardioLogsForSession(String workoutSessionId) async {}

  @override
  Future<void> deleteStrengthLogsForSession(String workoutSessionId) async {}

  @override
  Future<void> deleteWorkoutSession(String sessionId) async {}

  @override
  Future<StrengthSetLog?> getLastUsedWeight(String exerciseTemplateId) async {
    if (exerciseTemplateId == 'exercise_strength') {
      return StrengthSetLog(
        id: 'log_1',
        workoutSessionId: 'session_1',
        exerciseTemplateId: exerciseTemplateId,
        setIndex: 0,
        performedReps: 8,
        performedWeight: 62.5,
        isCompleted: true,
        completedAt: DateTime(2026),
      );
    }
    return null;
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
  Future<WorkoutSession?> getSessionForPlanDayAndDate({
    required String planDayId,
    required DateTime sessionDate,
  }) async {
    return null;
  }
}

class _TodaySettingsRepository implements SettingsRepository {
  @override
  Future<AppSettings?> getSettings() async {
    return const AppSettings(
      id: 'settings',
      themeMode: AppThemePreference.system,
      weightUnit: WeightUnit.kg,
      firstLaunchCompleted: true,
      lastBackupAt: null,
      preferredGraphRange: ProgressRange.last30Days,
    );
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {}
}
