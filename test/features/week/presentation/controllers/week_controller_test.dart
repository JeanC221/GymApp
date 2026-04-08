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
import 'package:smartfit/features/week/presentation/controllers/week_controller.dart';

void main() {
  group('WeekController', () {
    late ProviderContainer container;
    late _MemoryScheduleRepository scheduleRepository;

    setUp(() {
      scheduleRepository = _MemoryScheduleRepository();
      container = ProviderContainer(
        overrides: [
          appBootstrapProvider.overrideWith(
            (ref) async => AppBootstrap(
              scheduleRepository: scheduleRepository,
              workoutRepository: _MemoryWorkoutRepository(),
              settingsRepository: _MemorySettingsRepository(),
            ),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('creates a day into the active plan', () async {
      await container.read(weekControllerProvider.future);

      await container.read(weekControllerProvider.notifier).createDay(
            weekday: Weekday.thursday,
            type: PlanDayType.training,
            routineName: 'Lower',
          );

      final state = await container.read(weekControllerProvider.future);
      expect(state.days, hasLength(1));
      expect(state.days.single.day.weekday, Weekday.thursday);
      expect(state.days.single.day.routineName, 'Lower');
    });

    test('prevents converting a training day with exercises to rest without force', () async {
      scheduleRepository.seedPlanDay(
        PlanDay(
          id: 'day_1',
          weeklyPlanId: 'plan_1',
          weekday: Weekday.monday,
          type: PlanDayType.training,
          routineName: 'Push',
          orderIndex: 0,
        ),
      );
      scheduleRepository.seedStrengthExercise(
        dayId: 'day_1',
        exercise: ExerciseTemplate(
          id: 'exercise_1',
          planDayId: 'day_1',
          type: ExerciseType.strength,
          orderIndex: 0,
          displayName: 'Bench Press',
        ),
        template: StrengthTemplate(
          exerciseTemplateId: 'exercise_1',
          targetSets: 3,
          targetReps: 8,
        ),
      );

      await container.read(weekControllerProvider.future);

      expect(
        () => container.read(weekControllerProvider.notifier).updateDay(
              dayId: 'day_1',
              weekday: Weekday.monday,
              type: PlanDayType.rest,
            ),
        throwsA(isA<StateError>()),
      );
    });

    test('forces rest conversion by deleting exercises first', () async {
      scheduleRepository.seedPlanDay(
        PlanDay(
          id: 'day_1',
          weeklyPlanId: 'plan_1',
          weekday: Weekday.monday,
          type: PlanDayType.training,
          routineName: 'Push',
          orderIndex: 0,
        ),
      );
      scheduleRepository.seedStrengthExercise(
        dayId: 'day_1',
        exercise: ExerciseTemplate(
          id: 'exercise_1',
          planDayId: 'day_1',
          type: ExerciseType.strength,
          orderIndex: 0,
          displayName: 'Bench Press',
        ),
        template: StrengthTemplate(
          exerciseTemplateId: 'exercise_1',
          targetSets: 3,
          targetReps: 8,
        ),
      );

      await container.read(weekControllerProvider.future);

      await container.read(weekControllerProvider.notifier).updateDay(
            dayId: 'day_1',
            weekday: Weekday.monday,
            type: PlanDayType.rest,
            forceRestConversion: true,
          );

      final state = await container.read(weekControllerProvider.future);
      expect(state.days.single.day.isRestDay, isTrue);
      expect(await scheduleRepository.listExercises('day_1'), isEmpty);
    });

    test('moves a day to another free weekday', () async {
      scheduleRepository.seedPlanDay(
        PlanDay(
          id: 'day_1',
          weeklyPlanId: 'plan_1',
          weekday: Weekday.monday,
          type: PlanDayType.training,
          routineName: 'Push',
          orderIndex: 0,
        ),
      );

      await container.read(weekControllerProvider.future);

      await container.read(weekControllerProvider.notifier).moveDayToWeekday(
            dayId: 'day_1',
            weekday: Weekday.friday,
          );

      final state = await container.read(weekControllerProvider.future);
      expect(state.days.single.day.weekday, Weekday.friday);
    });

    test('reorders day positions', () async {
      scheduleRepository.seedPlanDay(
        PlanDay(
          id: 'day_1',
          weeklyPlanId: 'plan_1',
          weekday: Weekday.monday,
          type: PlanDayType.training,
          routineName: 'Push',
          orderIndex: 0,
        ),
      );
      scheduleRepository.seedPlanDay(
        PlanDay(
          id: 'day_2',
          weeklyPlanId: 'plan_1',
          weekday: Weekday.wednesday,
          type: PlanDayType.rest,
          orderIndex: 1,
        ),
      );

      await container.read(weekControllerProvider.future);

      await container.read(weekControllerProvider.notifier).moveDayPosition(
            dayId: 'day_2',
            offset: -1,
          );

      final state = await container.read(weekControllerProvider.future);
      expect(state.days.first.day.id, 'day_2');
      expect(state.days.last.day.id, 'day_1');
    });

    test('deletes a day without history', () async {
      scheduleRepository.seedPlanDay(
        PlanDay(
          id: 'day_1',
          weeklyPlanId: 'plan_1',
          weekday: Weekday.monday,
          type: PlanDayType.training,
          routineName: 'Push',
          orderIndex: 0,
        ),
      );

      await container.read(weekControllerProvider.future);
      await container.read(weekControllerProvider.notifier).deleteDay('day_1');

      final state = await container.read(weekControllerProvider.future);
      expect(state.days, isEmpty);
    });
  });
}

class _MemoryScheduleRepository implements ScheduleRepository {
  _MemoryScheduleRepository()
      : _activePlan = WeeklyPlan(
          id: 'plan_1',
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
          isActive: true,
        );

  WeeklyPlan? _activePlan;
  final List<PlanDay> _days = [];
  final Map<String, List<ExerciseTemplate>> _exercisesByDay = {};
  final Map<String, StrengthTemplate> _strengthByExercise = {};
  final Map<String, CardioTemplate> _cardioByExercise = {};

  void seedPlanDay(PlanDay day) {
    _upsertDay(day);
  }

  void seedStrengthExercise({
    required String dayId,
    required ExerciseTemplate exercise,
    required StrengthTemplate template,
  }) {
    final items = _exercisesByDay.putIfAbsent(dayId, () => []);
    items.removeWhere((item) => item.id == exercise.id);
    items.add(exercise);
    _strengthByExercise[exercise.id] = template;
  }

  @override
  Future<void> deleteExercise(String exerciseTemplateId) async {
    for (final entry in _exercisesByDay.entries) {
      entry.value.removeWhere((item) => item.id == exerciseTemplateId);
    }
    _strengthByExercise.remove(exerciseTemplateId);
    _cardioByExercise.remove(exerciseTemplateId);
  }

  @override
  Future<void> deletePlanDay(String planDayId) async {
    _days.removeWhere((item) => item.id == planDayId);
    _exercisesByDay.remove(planDayId);
  }

  @override
  Future<WeeklyPlan?> getActivePlan() async => _activePlan;

  @override
  Future<CardioTemplate?> getCardioTemplate(String exerciseTemplateId) async {
    return _cardioByExercise[exerciseTemplateId];
  }

  @override
  Future<PlanDay?> getPlanDayByWeekday(String weeklyPlanId, Weekday weekday) async {
    for (final day in _days) {
      if (day.weeklyPlanId == weeklyPlanId && day.weekday == weekday) {
        return day;
      }
    }
    return null;
  }

  @override
  Future<PlanDay?> getPlanDayForDate(DateTime date) async {
    final weekday = Weekday.values[date.weekday - 1];
    return getPlanDayByWeekday(_activePlan!.id, weekday);
  }

  @override
  Future<StrengthTemplate?> getStrengthTemplate(String exerciseTemplateId) async {
    return _strengthByExercise[exerciseTemplateId];
  }

  @override
  Future<List<PlanDay>> listCreatedDays(String weeklyPlanId) async {
    return listPlanDays(weeklyPlanId);
  }

  @override
  Future<List<ExerciseTemplate>> listExercises(String planDayId) async {
    final items = [...?_exercisesByDay[planDayId]];
    items.sort((left, right) => left.orderIndex.compareTo(right.orderIndex));
    return items;
  }

  @override
  Future<List<PlanDay>> listPlanDays(String weeklyPlanId) async {
    final items = _days.where((item) => item.weeklyPlanId == weeklyPlanId).toList();
    items.sort((left, right) => left.orderIndex.compareTo(right.orderIndex));
    return items;
  }

  @override
  Future<void> reorderExercises(String planDayId, List<ExerciseTemplate> orderedExercises) async {
    _exercisesByDay[planDayId] = [
      for (var index = 0; index < orderedExercises.length; index++)
        orderedExercises[index].copyWith(orderIndex: index),
    ];
  }

  @override
  Future<void> reorderPlanDays(List<PlanDay> orderedDays) async {
    _days
      ..clear()
      ..addAll([
        for (var index = 0; index < orderedDays.length; index++)
          orderedDays[index].copyWith(orderIndex: index),
      ]);
  }

  @override
  Future<void> saveCardioExercise({
    required ExerciseTemplate exercise,
    required CardioTemplate template,
  }) async {
    final items = _exercisesByDay.putIfAbsent(exercise.planDayId, () => []);
    items.removeWhere((item) => item.id == exercise.id);
    items.add(exercise);
    _cardioByExercise[exercise.id] = template;
  }

  @override
  Future<void> savePlanDay(PlanDay day) async {
    _upsertDay(day);
  }

  @override
  Future<void> saveStrengthExercise({
    required ExerciseTemplate exercise,
    required StrengthTemplate template,
  }) async {
    seedStrengthExercise(dayId: exercise.planDayId, exercise: exercise, template: template);
  }

  @override
  Future<void> saveWeeklyPlan(WeeklyPlan plan) async {
    _activePlan = plan;
  }

  void _upsertDay(PlanDay day) {
    _days.removeWhere((item) => item.id == day.id);
    _days.add(day);
  }
}

class _MemoryWorkoutRepository implements WorkoutRepository {
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
  Future<WorkoutSession?> getSessionForPlanDayAndDate({
    required String planDayId,
    required DateTime sessionDate,
  }) async {
    return null;
  }
}

class _MemorySettingsRepository implements SettingsRepository {
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