import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartfit/app/bootstrap/app_bootstrap.dart';
import 'package:smartfit/app/theme/app_theme.dart';
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
import 'package:smartfit/features/day_detail/presentation/controllers/day_detail_controller.dart';
import 'package:smartfit/features/day_detail/presentation/pages/day_detail_page.dart';

void main() {
  group('DayDetailPage', () {
    testWidgets('tablet layout shows the day inspector sidebar', (tester) async {
      await _setSurfaceSize(tester, const Size(1200, 1600));

      final scheduleRepository = _MemoryScheduleRepository();
      final workoutRepository = _MemoryWorkoutRepository();
      scheduleRepository.seedPlanDay(_trainingDay('day_1', Weekday.monday, 0, 'Push'));
      scheduleRepository.seedPlanDay(_trainingDay('day_2', Weekday.tuesday, 1, 'Pull'));
      scheduleRepository.seedStrengthExercise(
        dayId: 'day_1',
        exerciseId: 'exercise_1',
        displayName: 'Bench Press',
        orderIndex: 0,
        targetSets: 4,
        targetReps: 8,
      );

      await _pumpDayDetailPage(
        tester,
        scheduleRepository: scheduleRepository,
        workoutRepository: workoutRepository,
      );

      expect(find.text('Day inspector'), findsOneWidget);
      expect(find.text('Template summary'), findsOneWidget);
      expect(find.text('Editing cues'), findsOneWidget);
    });

    testWidgets('move transfer sheet renders training targets and returns selection', (
      tester,
    ) async {
      PlanDay? selectedDay;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: ExerciseTransferSheet(
              title: 'Move exercise',
              subtitle:
                  'Move this exercise template to another training day and keep the weekly order stable.',
              targetDays: [
                _trainingDay('day_2', Weekday.tuesday, 1, 'Pull'),
                _trainingDay('day_3', Weekday.thursday, 2, 'Legs'),
              ],
              onSelectDay: (day) => selectedDay = day,
            ),
          ),
        ),
      );

      expect(find.text('Move exercise'), findsOneWidget);
      expect(find.text('Tuesday · Pull'), findsOneWidget);
      expect(find.text('Thursday · Legs'), findsOneWidget);

      await tester.tap(find.text('Thursday · Legs'));
      await tester.pump();

      expect(selectedDay?.id, 'day_3');
    });

    testWidgets('copy transfer sheet renders title and returns selection', (tester) async {
      PlanDay? selectedDay;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: ExerciseTransferSheet(
              title: 'Copy exercise',
              subtitle:
                  'Create a new copy of this exercise template in another training day.',
              targetDays: [
                _trainingDay('day_2', Weekday.tuesday, 1, 'Pull'),
              ],
              onSelectDay: (day) => selectedDay = day,
            ),
          ),
        ),
      );

      expect(find.text('Copy exercise'), findsOneWidget);
      expect(find.text('Tuesday · Pull'), findsOneWidget);

      await tester.tap(find.text('Tuesday · Pull'));
      await tester.pump();

      expect(selectedDay?.id, 'day_2');
    });

    testWidgets('trim dialog renders conflict details and confirms action', (tester) async {
      var confirmed = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: StrengthSetTrimConfirmDialog(
              conflict: const StrengthSetReductionConflict(
                keepSets: 2,
                trimmedLogCount: 2,
              ),
              onConfirm: () => confirmed = true,
            ),
          ),
        ),
      );

      expect(find.text('Trim saved set logs?'), findsOneWidget);
      expect(find.textContaining('Reducing this exercise to 2 sets'), findsOneWidget);
      expect(find.text('Trim and save'), findsOneWidget);

      await tester.tap(find.text('Trim and save'));
      await tester.pumpAndSettle();

      expect(confirmed, isTrue);
    });

    testWidgets('page shows drag handles for exercise reordering', (tester) async {
      final scheduleRepository = _MemoryScheduleRepository();
      final workoutRepository = _MemoryWorkoutRepository();
      scheduleRepository.seedPlanDay(_trainingDay('day_1', Weekday.monday, 0, 'Push'));
      scheduleRepository.seedPlanDay(_trainingDay('day_2', Weekday.tuesday, 1, 'Pull'));
      scheduleRepository.seedStrengthExercise(
        dayId: 'day_1',
        exerciseId: 'exercise_1',
        displayName: 'Bench Press',
        orderIndex: 0,
        targetSets: 4,
        targetReps: 8,
      );
      scheduleRepository.seedStrengthExercise(
        dayId: 'day_1',
        exerciseId: 'exercise_2',
        displayName: 'Incline Press',
        orderIndex: 1,
        targetSets: 3,
        targetReps: 10,
      );

      await _pumpDayDetailPage(
        tester,
        scheduleRepository: scheduleRepository,
        workoutRepository: workoutRepository,
      );

      expect(find.text('Bench Press'), findsOneWidget);
      expect(find.text('Incline Press'), findsOneWidget);
      expect(find.byIcon(Icons.drag_indicator_rounded), findsNWidgets(2));
      expect(find.text('Drag to reorder'), findsNWidgets(2));
    });
  });
}

Future<void> _pumpDayDetailPage(
  WidgetTester tester, {
  required _MemoryScheduleRepository scheduleRepository,
  required _MemoryWorkoutRepository workoutRepository,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appBootstrapProvider.overrideWith(
          (ref) async => AppBootstrap(
            scheduleRepository: scheduleRepository,
            workoutRepository: workoutRepository,
            settingsRepository: _MemorySettingsRepository(),
          ),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: DayDetailPage(dayId: 'day_1'),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

PlanDay _trainingDay(String id, Weekday weekday, int orderIndex, String routineName) {
  return PlanDay(
    id: id,
    weeklyPlanId: 'plan_1',
    weekday: weekday,
    type: PlanDayType.training,
    routineName: routineName,
    orderIndex: orderIndex,
  );
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
    required String exerciseId,
    required String displayName,
    required int orderIndex,
    required int targetSets,
    required int targetReps,
  }) {
    final items = _exercisesByDay.putIfAbsent(dayId, () => []);
    items.add(
      ExerciseTemplate(
        id: exerciseId,
        planDayId: dayId,
        type: ExerciseType.strength,
        orderIndex: orderIndex,
        displayName: displayName,
      ),
    );
    _strengthByExercise[exerciseId] = StrengthTemplate(
      exerciseTemplateId: exerciseId,
      targetSets: targetSets,
      targetReps: targetReps,
    );
  }

  List<String> exerciseNamesForDay(String dayId) {
    final items = [...?_exercisesByDay[dayId]];
    items.sort((left, right) => left.orderIndex.compareTo(right.orderIndex));
    return items.map((item) => item.displayName).toList(growable: false);
  }

  List<String> exerciseIdsForDay(String dayId) {
    final items = [...?_exercisesByDay[dayId]];
    items.sort((left, right) => left.orderIndex.compareTo(right.orderIndex));
    return items.map((item) => item.id).toList(growable: false);
  }

  StrengthTemplate? strengthTemplateFor(String exerciseId) {
    return _strengthByExercise[exerciseId];
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
    _sessions.add(session);
  }

  void seedStrengthLogs(String sessionId, List<StrengthSetLog> logs) {
    _strengthLogsBySession[sessionId] = [...logs];
  }

  List<int> exerciseSetIndexes(String sessionId, String exerciseId) {
    final logs = [...?_strengthLogsBySession[sessionId]]
      ..retainWhere((item) => item.exerciseTemplateId == exerciseId)
      ..sort((left, right) => left.setIndex.compareTo(right.setIndex));
    return logs.map((item) => item.setIndex).toList(growable: false);
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

Future<void> _setSurfaceSize(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  await tester.pump();
}