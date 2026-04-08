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
import 'package:smartfit/core/domain/enums/plan_day_type.dart';
import 'package:smartfit/core/domain/enums/progress_range.dart';
import 'package:smartfit/core/domain/enums/weekday.dart';
import 'package:smartfit/core/domain/enums/weight_unit.dart';
import 'package:smartfit/core/domain/enums/workout_session_status.dart';
import 'package:smartfit/core/domain/repositories/schedule_repository.dart';
import 'package:smartfit/core/domain/repositories/settings_repository.dart';
import 'package:smartfit/core/domain/repositories/workout_repository.dart';
import 'package:smartfit/features/day_detail/presentation/controllers/day_detail_controller.dart';

void main() {
  group('DayDetailController', () {
    late ProviderContainer container;
    late _MemoryScheduleRepository scheduleRepository;
    late _MemoryWorkoutRepository workoutRepository;

    setUp(() {
      scheduleRepository = _MemoryScheduleRepository();
      workoutRepository = _MemoryWorkoutRepository();
      scheduleRepository.seedPlanDay(
        PlanDay(
          id: 'day_1',
          weeklyPlanId: 'plan_1',
          weekday: Weekday.values[DateTime.now().weekday - 1],
          type: PlanDayType.training,
          routineName: 'Push',
          orderIndex: 0,
        ),
      );

      container = ProviderContainer(
        overrides: [
          appBootstrapProvider.overrideWith(
            (ref) async => AppBootstrap(
              scheduleRepository: scheduleRepository,
              workoutRepository: workoutRepository,
              settingsRepository: _MemorySettingsRepository(),
            ),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('add, update and delete strength exercise', () async {
      final controller = container.read(dayDetailControllerProvider('day_1'));

      await controller.addStrengthExercise(
        displayName: 'Bench Press',
        targetSets: 4,
        targetReps: 8,
      );

      var detail = await container.read(dayDetailProvider('day_1').future);
      expect(detail.exercises, hasLength(1));
      expect(detail.exercises.single.exercise.displayName, 'Bench Press');
      expect(detail.exercises.single.strengthTemplate?.targetSets, 4);

      final item = detail.exercises.single;
      await controller.updateStrengthExercise(
        exercise: item.exercise,
        template: item.strengthTemplate!,
        displayName: 'Incline Bench Press',
        targetSets: 5,
        targetReps: 10,
      );

      detail = await container.read(dayDetailProvider('day_1').future);
      expect(detail.exercises.single.exercise.displayName, 'Incline Bench Press');
      expect(detail.exercises.single.strengthTemplate?.targetSets, 5);
      expect(detail.exercises.single.strengthTemplate?.targetReps, 10);

      await controller.deleteExercise(detail.exercises.single.exercise.id);

      detail = await container.read(dayDetailProvider('day_1').future);
      expect(detail.exercises, isEmpty);
    });

    test('creates in-progress session and saves strength logs with real values', () async {
      final controller = container.read(dayDetailControllerProvider('day_1'));
      await controller.addStrengthExercise(
        displayName: 'Bench Press',
        targetSets: 3,
        targetReps: 8,
      );

      final detail = await container.read(dayDetailProvider('day_1').future);
      final exercise = detail.exercises.single.exercise;

      await controller.saveStrengthLogs(
        exercise: exercise,
        drafts: const [
          StrengthSetLogDraft(
            isCompleted: true,
            performedReps: 8,
            performedWeight: 60,
          ),
          StrengthSetLogDraft(
            isCompleted: true,
            performedReps: 8,
            performedWeight: 62.5,
          ),
          StrengthSetLogDraft(
            isCompleted: false,
            performedReps: null,
            performedWeight: null,
          ),
        ],
      );

      final session = await workoutRepository.getSessionForPlanDayAndDate(
        planDayId: 'day_1',
        sessionDate: DateTime.now(),
      );
      expect(session, isNotNull);
      expect(session!.sessionStatus, WorkoutSessionStatus.inProgress);

      final logs = await workoutRepository.listStrengthSetLogs(session.id);
      expect(logs, hasLength(3));
      expect(logs[0].performedWeight, 60);
      expect(logs[1].performedWeight, 62.5);
      expect(logs[2].isCompleted, isFalse);
    });

    test('saves and clears a manual cardio log', () async {
      final controller = container.read(dayDetailControllerProvider('day_1'));
      await controller.addCardioExercise(
        displayName: 'Treadmill',
        cardioType: 'Treadmill',
        durationMinutes: 20,
        incline: 5,
      );

      final detail = await container.read(dayDetailProvider('day_1').future);
      final exercise = detail.exercises.single.exercise;

      await controller.saveCardioLog(
        exercise: exercise,
        cardioType: 'Treadmill',
        durationMinutes: 25,
        incline: 6,
      );

      final session = await workoutRepository.getSessionForPlanDayAndDate(
        planDayId: 'day_1',
        sessionDate: DateTime.now(),
      );
      final logs = await workoutRepository.listCardioLogs(session!.id);
      expect(logs, hasLength(1));
      expect(logs.single.durationMinutes, 25);
      expect(logs.single.incline, 6);

      await controller.deleteCardioLog(exercise.id);
      expect(await workoutRepository.listCardioLogs(session.id), isEmpty);
    });

    test('completes the session for today', () async {
      final controller = container.read(dayDetailControllerProvider('day_1'));

      await controller.startTodaySession();
      await controller.completeTodaySession();

      final session = await workoutRepository.getSessionForPlanDayAndDate(
        planDayId: 'day_1',
        sessionDate: DateTime.now(),
      );
      expect(session, isNotNull);
      expect(session!.sessionStatus, WorkoutSessionStatus.completed);
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

  @override
  Future<WeeklyPlan?> getActivePlan() async => _activePlan;

  @override
  Future<void> saveWeeklyPlan(WeeklyPlan plan) async {
    _activePlan = plan;
  }

  @override
  Future<List<PlanDay>> listPlanDays(String weeklyPlanId) async {
    final items = _days.where((item) => item.weeklyPlanId == weeklyPlanId).toList();
    items.sort((left, right) => left.orderIndex.compareTo(right.orderIndex));
    return items;
  }

  @override
  Future<List<PlanDay>> listCreatedDays(String weeklyPlanId) async {
    return listPlanDays(weeklyPlanId);
  }

  @override
  Future<PlanDay?> getPlanDayForDate(DateTime date) async {
    final weekday = Weekday.values[date.weekday - 1];
    return getPlanDayByWeekday(_activePlan!.id, weekday);
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
  Future<void> savePlanDay(PlanDay day) async {
    _upsertDay(day);
  }

  @override
  Future<void> deletePlanDay(String planDayId) async {
    _days.removeWhere((item) => item.id == planDayId);
    _exercisesByDay.remove(planDayId);
  }

  @override
  Future<List<ExerciseTemplate>> listExercises(String planDayId) async {
    final items = [...?_exercisesByDay[planDayId]];
    items.sort((left, right) => left.orderIndex.compareTo(right.orderIndex));
    return items;
  }

  @override
  Future<StrengthTemplate?> getStrengthTemplate(String exerciseTemplateId) async {
    return _strengthByExercise[exerciseTemplateId];
  }

  @override
  Future<CardioTemplate?> getCardioTemplate(String exerciseTemplateId) async {
    return _cardioByExercise[exerciseTemplateId];
  }

  @override
  Future<void> saveStrengthExercise({
    required ExerciseTemplate exercise,
    required StrengthTemplate template,
  }) async {
    final items = _exercisesByDay.putIfAbsent(exercise.planDayId, () => []);
    items.removeWhere((item) => item.id == exercise.id);
    items.add(exercise);
    _strengthByExercise[exercise.id] = template;
    _cardioByExercise.remove(exercise.id);
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
    _strengthByExercise.remove(exercise.id);
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
  Future<void> reorderPlanDays(List<PlanDay> orderedDays) async {
    _days
      ..clear()
      ..addAll([
        for (var index = 0; index < orderedDays.length; index++)
          orderedDays[index].copyWith(orderIndex: index),
      ]);
  }

  @override
  Future<void> reorderExercises(
    String planDayId,
    List<ExerciseTemplate> orderedExercises,
  ) async {
    _exercisesByDay[planDayId] = [
      for (var index = 0; index < orderedExercises.length; index++)
        orderedExercises[index].copyWith(orderIndex: index),
    ];
  }

  void _upsertDay(PlanDay day) {
    _days.removeWhere((item) => item.id == day.id);
    _days.add(day);
  }
}

class _MemoryWorkoutRepository implements WorkoutRepository {
  final List<WorkoutSession> _sessions = [];
  final Map<String, List<StrengthSetLog>> _strengthLogsBySession = {};
  final Map<String, List<CardioLog>> _cardioLogsBySession = {};

  @override
  Future<WorkoutSession?> getSessionForPlanDayAndDate({
    required String planDayId,
    required DateTime sessionDate,
  }) async {
    final normalized = DateTime(sessionDate.year, sessionDate.month, sessionDate.day);
    for (final session in _sessions) {
      if (session.planDayId == planDayId && session.sessionDate == normalized) {
        return session;
      }
    }
    return null;
  }

  @override
  Future<List<WorkoutSession>> listSessionsForPlanDay(String planDayId) async {
    return _sessions.where((item) => item.planDayId == planDayId).toList(growable: false);
  }

  @override
  Future<void> saveWorkoutSession(WorkoutSession session) async {
    _sessions.removeWhere((item) => item.id == session.id);
    _sessions.add(session);
  }

  @override
  Future<void> deleteWorkoutSession(String sessionId) async {
    _sessions.removeWhere((item) => item.id == sessionId);
    _strengthLogsBySession.remove(sessionId);
    _cardioLogsBySession.remove(sessionId);
  }

  @override
  Future<List<StrengthSetLog>> listStrengthSetLogs(String workoutSessionId) async {
    return [...?_strengthLogsBySession[workoutSessionId]];
  }

  @override
  Future<void> saveStrengthSetLog(StrengthSetLog log) async {
    final items = _strengthLogsBySession.putIfAbsent(log.workoutSessionId, () => []);
    items.removeWhere((item) => item.id == log.id);
    items.add(log);
  }

  @override
  Future<void> saveStrengthSetLogs(List<StrengthSetLog> logs) async {
    for (final log in logs) {
      await saveStrengthSetLog(log);
    }
  }

  @override
  Future<void> deleteStrengthLogsForSession(String workoutSessionId) async {
    _strengthLogsBySession[workoutSessionId] = [];
  }

  @override
  Future<List<CardioLog>> listCardioLogs(String workoutSessionId) async {
    return [...?_cardioLogsBySession[workoutSessionId]];
  }

  @override
  Future<void> saveCardioLog(CardioLog log) async {
    final items = _cardioLogsBySession.putIfAbsent(log.workoutSessionId, () => []);
    items.removeWhere((item) => item.id == log.id);
    items.add(log);
  }

  @override
  Future<void> saveCardioLogs(List<CardioLog> logs) async {
    for (final log in logs) {
      await saveCardioLog(log);
    }
  }

  @override
  Future<void> deleteCardioLogsForSession(String workoutSessionId) async {
    _cardioLogsBySession[workoutSessionId] = [];
  }

  @override
  Future<StrengthSetLog?> getLastUsedWeight(String exerciseTemplateId) async {
    final allLogs = _strengthLogsBySession.values.expand((item) => item);
    StrengthSetLog? latest;
    for (final log in allLogs) {
      if (log.exerciseTemplateId != exerciseTemplateId || !log.isCompleted) {
        continue;
      }
      final currentCompleted = log.completedAt;
      final latestCompleted = latest?.completedAt;
      if (latest == null ||
          (currentCompleted != null && latestCompleted != null && currentCompleted.isAfter(latestCompleted)) ||
          (currentCompleted != null && latestCompleted == null)) {
        latest = log;
      }
    }
    return latest;
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