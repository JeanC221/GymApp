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
import 'package:smartfit/core/domain/enums/cardio_source.dart';
import 'package:smartfit/core/domain/enums/exercise_type.dart';
import 'package:smartfit/core/domain/enums/plan_day_type.dart';
import 'package:smartfit/core/domain/enums/progress_range.dart';
import 'package:smartfit/core/domain/enums/weekday.dart';
import 'package:smartfit/core/domain/enums/weight_unit.dart';
import 'package:smartfit/core/domain/enums/workout_session_status.dart';
import 'package:smartfit/core/domain/repositories/schedule_repository.dart';
import 'package:smartfit/core/domain/repositories/settings_repository.dart';
import 'package:smartfit/core/domain/repositories/workout_repository.dart';
import 'package:smartfit/features/progress/presentation/providers/progress_overview_provider.dart';

void main() {
  group('progressOverviewProvider', () {
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
          weekday: Weekday.monday,
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

    test('builds strength history and last used reference from real logs', () async {
      await scheduleRepository.saveStrengthExercise(
        exercise: ExerciseTemplate(
          id: 'exercise_strength',
          planDayId: 'day_1',
          type: ExerciseType.strength,
          orderIndex: 0,
          displayName: 'Bench Press',
        ),
        template: StrengthTemplate(
          exerciseTemplateId: 'exercise_strength',
          targetSets: 4,
          targetReps: 8,
        ),
      );

      final now = DateTime.now();
      final inRangeDateA = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 14));
      final inRangeDateB = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 3));
      final outOfRangeDate = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 60));

      workoutRepository.seedSession(
        WorkoutSession(
          id: 'session_old',
          planDayId: 'day_1',
          sessionDate: outOfRangeDate,
          sessionStatus: WorkoutSessionStatus.completed,
          createdAt: outOfRangeDate,
          updatedAt: outOfRangeDate,
        ),
      );
      workoutRepository.seedSession(
        WorkoutSession(
          id: 'session_a',
          planDayId: 'day_1',
          sessionDate: inRangeDateA,
          sessionStatus: WorkoutSessionStatus.completed,
          createdAt: inRangeDateA,
          updatedAt: inRangeDateA,
        ),
      );
      workoutRepository.seedSession(
        WorkoutSession(
          id: 'session_b',
          planDayId: 'day_1',
          sessionDate: inRangeDateB,
          sessionStatus: WorkoutSessionStatus.inProgress,
          createdAt: inRangeDateB,
          updatedAt: inRangeDateB,
        ),
      );

      workoutRepository.seedStrengthLogs('session_old', [
        StrengthSetLog(
          id: 'log_old',
          workoutSessionId: 'session_old',
          exerciseTemplateId: 'exercise_strength',
          setIndex: 0,
          performedReps: 8,
          performedWeight: 52.5,
          isCompleted: true,
          completedAt: outOfRangeDate,
        ),
      ]);
      workoutRepository.seedStrengthLogs('session_a', [
        StrengthSetLog(
          id: 'log_a0',
          workoutSessionId: 'session_a',
          exerciseTemplateId: 'exercise_strength',
          setIndex: 0,
          performedReps: 8,
          performedWeight: 60,
          isCompleted: true,
          completedAt: inRangeDateA,
        ),
        StrengthSetLog(
          id: 'log_a1',
          workoutSessionId: 'session_a',
          exerciseTemplateId: 'exercise_strength',
          setIndex: 1,
          performedReps: 7,
          performedWeight: 62.5,
          isCompleted: true,
          completedAt: inRangeDateA,
        ),
      ]);
      workoutRepository.seedStrengthLogs('session_b', [
        StrengthSetLog(
          id: 'log_b0',
          workoutSessionId: 'session_b',
          exerciseTemplateId: 'exercise_strength',
          setIndex: 0,
          performedReps: 8,
          performedWeight: 65,
          isCompleted: true,
          completedAt: inRangeDateB,
        ),
      ]);

      final overview = await container.read(
        progressOverviewProvider(ProgressRange.last30Days).future,
      );
      final history = overview.defaultExerciseHistory!;

      expect(history.displayName, 'Bench Press');
      expect(history.lastUsedWeight, 65);
      expect(history.completedStrengthSets, 3);
      expect(history.series.map((point) => point.value).toList(), [62.5, 65]);
      expect(overview.completedSessionCount, 1);
    });

    test('builds cardio and overall summaries inside the selected range', () async {
      await scheduleRepository.saveCardioExercise(
        exercise: ExerciseTemplate(
          id: 'exercise_cardio',
          planDayId: 'day_1',
          type: ExerciseType.cardio,
          orderIndex: 0,
          displayName: 'Treadmill',
        ),
        template: CardioTemplate(
          exerciseTemplateId: 'exercise_cardio',
          cardioType: 'Treadmill',
          defaultDurationMinutes: 20,
          defaultIncline: 5,
        ),
      );

      final now = DateTime.now();
      final weekA = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 10));
      final weekB = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 2));

      workoutRepository.seedSession(
        WorkoutSession(
          id: 'session_cardio_a',
          planDayId: 'day_1',
          sessionDate: weekA,
          sessionStatus: WorkoutSessionStatus.completed,
          createdAt: weekA,
          updatedAt: weekA,
        ),
      );
      workoutRepository.seedSession(
        WorkoutSession(
          id: 'session_cardio_b',
          planDayId: 'day_1',
          sessionDate: weekB,
          sessionStatus: WorkoutSessionStatus.completed,
          createdAt: weekB,
          updatedAt: weekB,
        ),
      );

      workoutRepository.seedCardioLogs('session_cardio_a', [
        CardioLog(
          id: 'cardio_a',
          workoutSessionId: 'session_cardio_a',
          exerciseTemplateId: 'exercise_cardio',
          source: CardioSource.manual,
          cardioType: 'Treadmill',
          durationMinutes: 20,
          incline: 5,
        ),
      ]);
      workoutRepository.seedCardioLogs('session_cardio_b', [
        CardioLog(
          id: 'cardio_b',
          workoutSessionId: 'session_cardio_b',
          exerciseTemplateId: 'exercise_cardio',
          source: CardioSource.manual,
          cardioType: 'Treadmill',
          durationMinutes: 25,
          incline: 6,
        ),
      ]);

      final overview = await container.read(
        progressOverviewProvider(ProgressRange.last30Days).future,
      );
      final history = overview.defaultExerciseHistory!;

      expect(history.type, ExerciseType.cardio);
      expect(history.totalCardioMinutes, 45);
      expect(history.series.map((point) => point.value).toList(), [20, 25]);
      expect(overview.completedSessionCount, 2);
      expect(overview.totalCardioMinutes, 45);
      expect(overview.overallCompletedSessionSeries, hasLength(2));
      expect(overview.overallCardioMinuteSeries.map((point) => point.value).toList(), [20, 25]);
    });

    test('returns exercise options with empty history when no logs exist yet', () async {
      await scheduleRepository.saveStrengthExercise(
        exercise: ExerciseTemplate(
          id: 'exercise_strength',
          planDayId: 'day_1',
          type: ExerciseType.strength,
          orderIndex: 0,
          displayName: 'Bench Press',
        ),
        template: StrengthTemplate(
          exerciseTemplateId: 'exercise_strength',
          targetSets: 4,
          targetReps: 8,
        ),
      );

      final overview = await container.read(
        progressOverviewProvider(ProgressRange.last30Days).future,
      );

      expect(overview.exerciseHistories, hasLength(1));
      expect(overview.defaultExerciseHistory?.hasHistory, isFalse);
      expect(overview.hasAnyHistory, isFalse);
      expect(overview.completedSessionCount, 0);
      expect(overview.completedStrengthSetCount, 0);
      expect(overview.totalCardioMinutes, 0);
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

  void seedSession(WorkoutSession session) {
    _sessions.removeWhere((item) => item.id == session.id);
    _sessions.add(session);
  }

  void seedStrengthLogs(String sessionId, List<StrengthSetLog> logs) {
    _strengthLogsBySession[sessionId] = [...logs];
  }

  void seedCardioLogs(String sessionId, List<CardioLog> logs) {
    _cardioLogsBySession[sessionId] = [...logs];
  }

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