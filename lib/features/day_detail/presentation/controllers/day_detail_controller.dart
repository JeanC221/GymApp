import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartfit/app/bootstrap/app_bootstrap.dart';
import 'package:smartfit/core/domain/entities/cardio_log.dart';
import 'package:smartfit/core/domain/entities/cardio_template.dart';
import 'package:smartfit/core/domain/entities/exercise_template.dart';
import 'package:smartfit/core/domain/entities/plan_day.dart';
import 'package:smartfit/core/domain/entities/strength_set_log.dart';
import 'package:smartfit/core/domain/entities/strength_template.dart';
import 'package:smartfit/core/domain/entities/workout_session.dart';
import 'package:smartfit/core/domain/enums/cardio_source.dart';
import 'package:smartfit/core/domain/enums/exercise_type.dart';
import 'package:smartfit/core/domain/enums/workout_session_status.dart';
import 'package:smartfit/core/utils/app_id_factory.dart';
import 'package:smartfit/features/week/presentation/controllers/week_controller.dart';

final dayDetailProvider =
    FutureProvider.family<DayDetailState, String>((ref, dayId) async {
  ref.watch(weekRefreshTickProvider);
  ref.watch(workoutRefreshTickProvider);

  final bootstrap = await ref.watch(appBootstrapProvider.future);
  final scheduleRepository = bootstrap.scheduleRepository;
  final workoutRepository = bootstrap.workoutRepository;
  final activePlan = await scheduleRepository.getActivePlan();
  if (activePlan == null) {
    throw StateError('No active plan is available.');
  }

  final days = await scheduleRepository.listCreatedDays(activePlan.id);
  PlanDay? day;
  for (final item in days) {
    if (item.id == dayId) {
      day = item;
      break;
    }
  }

  if (day == null) {
    throw StateError('The requested day could not be found in the active plan.');
  }

  final today = DateTime.now();
  final session = await workoutRepository.getSessionForPlanDayAndDate(
    planDayId: dayId,
    sessionDate: today,
  );
  final strengthLogs = session == null
      ? const <StrengthSetLog>[]
      : await workoutRepository.listStrengthSetLogs(session.id);
  final cardioLogs = session == null
      ? const <CardioLog>[]
      : await workoutRepository.listCardioLogs(session.id);

  final exercises = await scheduleRepository.listExercises(dayId);
  final items = <DayExerciseDetail>[];

  for (final exercise in exercises) {
    if (exercise.type == ExerciseType.strength) {
      final template = await scheduleRepository.getStrengthTemplate(exercise.id);
      if (template != null) {
        final lastUsedWeight = await workoutRepository.getLastUsedWeight(exercise.id);
        items.add(
          DayExerciseDetail.strength(
            exercise: exercise,
            strengthTemplate: template,
            lastUsedWeight: lastUsedWeight?.performedWeight,
            strengthLogs: strengthLogs
                .where((item) => item.exerciseTemplateId == exercise.id)
                .toList(growable: false),
          ),
        );
      }
      continue;
    }

    final template = await scheduleRepository.getCardioTemplate(exercise.id);
    if (template != null) {
      CardioLog? matchingLog;
      for (final log in cardioLogs) {
        if (log.exerciseTemplateId == exercise.id) {
          matchingLog = log;
          break;
        }
      }

      items.add(
        DayExerciseDetail.cardio(
          exercise: exercise,
          cardioTemplate: template,
          cardioLog: matchingLog,
        ),
      );
    }
  }

  return DayDetailState(
    day: day,
    todaySession: session,
    exercises: items,
  );
});

final dayDetailControllerProvider =
    Provider.family<DayDetailController, String>((ref, dayId) {
  return DayDetailController(ref, dayId);
});

class DayDetailController {
  DayDetailController(this._ref, this.dayId);

  final Ref _ref;
  final String dayId;

  Future<void> startTodaySession() async {
    await _ensureTodaySession(forceInProgress: true);
    _bumpWorkout();
  }

  Future<void> completeTodaySession() async {
    final session = await _ensureTodaySession(forceInProgress: false);
    final now = DateTime.now();
    final bootstrap = await _ref.read(appBootstrapProvider.future);
    await bootstrap.workoutRepository.saveWorkoutSession(
      session.copyWith(
        sessionStatus: WorkoutSessionStatus.completed,
        updatedAt: now,
      ),
    );
    _bumpWorkout();
  }

  Future<void> addStrengthExercise({
    required String displayName,
    required int targetSets,
    required int targetReps,
  }) async {
    final bootstrap = await _ref.read(appBootstrapProvider.future);
    final repository = bootstrap.scheduleRepository;
    final orderIndex = (await repository.listExercises(dayId)).length;
    final exerciseId = AppIdFactory.next('exercise');

    await repository.saveStrengthExercise(
      exercise: ExerciseTemplate(
        id: exerciseId,
        planDayId: dayId,
        type: ExerciseType.strength,
        orderIndex: orderIndex,
        displayName: displayName.trim(),
      ),
      template: StrengthTemplate(
        exerciseTemplateId: exerciseId,
        targetSets: targetSets,
        targetReps: targetReps,
      ),
    );
    _bumpSchedule();
  }

  Future<void> updateStrengthExercise({
    required ExerciseTemplate exercise,
    required StrengthTemplate template,
    required String displayName,
    required int targetSets,
    required int targetReps,
  }) async {
    final bootstrap = await _ref.read(appBootstrapProvider.future);
    await bootstrap.scheduleRepository.saveStrengthExercise(
      exercise: exercise.copyWith(displayName: displayName.trim()),
      template: template.copyWith(
        targetSets: targetSets,
        targetReps: targetReps,
      ),
    );
    _bumpSchedule();
  }

  Future<void> addCardioExercise({
    required String displayName,
    required String cardioType,
    required int durationMinutes,
    double? incline,
  }) async {
    final bootstrap = await _ref.read(appBootstrapProvider.future);
    final repository = bootstrap.scheduleRepository;
    final orderIndex = (await repository.listExercises(dayId)).length;
    final exerciseId = AppIdFactory.next('exercise');

    await repository.saveCardioExercise(
      exercise: ExerciseTemplate(
        id: exerciseId,
        planDayId: dayId,
        type: ExerciseType.cardio,
        orderIndex: orderIndex,
        displayName: displayName.trim(),
      ),
      template: CardioTemplate(
        exerciseTemplateId: exerciseId,
        cardioType: cardioType.trim(),
        defaultDurationMinutes: durationMinutes,
        defaultIncline: incline,
      ),
    );
    _bumpSchedule();
  }

  Future<void> updateCardioExercise({
    required ExerciseTemplate exercise,
    required CardioTemplate template,
    required String displayName,
    required String cardioType,
    required int durationMinutes,
    double? incline,
  }) async {
    final bootstrap = await _ref.read(appBootstrapProvider.future);
    await bootstrap.scheduleRepository.saveCardioExercise(
      exercise: exercise.copyWith(displayName: displayName.trim()),
      template: template.copyWith(
        cardioType: cardioType.trim(),
        defaultDurationMinutes: durationMinutes,
        defaultIncline: incline,
      ),
    );
    _bumpSchedule();
  }

  Future<void> deleteExercise(String exerciseId) async {
    final bootstrap = await _ref.read(appBootstrapProvider.future);
    await bootstrap.scheduleRepository.deleteExercise(exerciseId);
    _bumpSchedule();
  }

  Future<void> saveStrengthLogs({
    required ExerciseTemplate exercise,
    required List<StrengthSetLogDraft> drafts,
  }) async {
    final bootstrap = await _ref.read(appBootstrapProvider.future);
    final workoutRepository = bootstrap.workoutRepository;
    final session = await _ensureTodaySession(forceInProgress: true);
    final existingLogs = await workoutRepository.listStrengthSetLogs(session.id);
    final retained = existingLogs
        .where((item) => item.exerciseTemplateId != exercise.id)
        .toList(growable: true);
    final logs = <StrengthSetLog>[];
    final now = DateTime.now();

    for (var index = 0; index < drafts.length; index++) {
      final draft = drafts[index];
      final existing = _findStrengthLog(existingLogs, exercise.id, index);
      logs.add(
        StrengthSetLog(
          id: existing?.id ?? AppIdFactory.next('strength_log'),
          workoutSessionId: session.id,
          exerciseTemplateId: exercise.id,
          setIndex: index,
          performedReps: draft.performedReps,
          performedWeight: draft.performedWeight,
          isCompleted: draft.isCompleted,
          completedAt: draft.isCompleted ? now : null,
        ),
      );
    }

    await workoutRepository.deleteStrengthLogsForSession(session.id);
    if (retained.isNotEmpty || logs.isNotEmpty) {
      await workoutRepository.saveStrengthSetLogs([...retained, ...logs]);
    }

    _bumpWorkout();
  }

  Future<void> saveCardioLog({
    required ExerciseTemplate exercise,
    required String cardioType,
    required int durationMinutes,
    double? incline,
  }) async {
    final bootstrap = await _ref.read(appBootstrapProvider.future);
    final workoutRepository = bootstrap.workoutRepository;
    final session = await _ensureTodaySession(forceInProgress: true);
    final existingLogs = await workoutRepository.listCardioLogs(session.id);
    final retained = existingLogs
        .where((item) => item.exerciseTemplateId != exercise.id)
        .toList(growable: true);
    final existing = _findCardioLog(existingLogs, exercise.id);

    await workoutRepository.deleteCardioLogsForSession(session.id);
    await workoutRepository.saveCardioLogs([
      ...retained,
      CardioLog(
        id: existing?.id ?? AppIdFactory.next('cardio_log'),
        workoutSessionId: session.id,
        exerciseTemplateId: exercise.id,
        source: CardioSource.manual,
        cardioType: cardioType.trim(),
        durationMinutes: durationMinutes,
        incline: incline,
      ),
    ]);

    _bumpWorkout();
  }

  Future<void> deleteCardioLog(String exerciseId) async {
    final bootstrap = await _ref.read(appBootstrapProvider.future);
    final workoutRepository = bootstrap.workoutRepository;
    final session = await workoutRepository.getSessionForPlanDayAndDate(
      planDayId: dayId,
      sessionDate: DateTime.now(),
    );
    if (session == null) {
      return;
    }

    final existingLogs = await workoutRepository.listCardioLogs(session.id);
    final retained = existingLogs
        .where((item) => item.exerciseTemplateId != exerciseId)
        .toList(growable: false);
    await workoutRepository.deleteCardioLogsForSession(session.id);
    if (retained.isNotEmpty) {
      await workoutRepository.saveCardioLogs(retained);
    }
    _bumpWorkout();
  }

  Future<WorkoutSession> _ensureTodaySession({
    required bool forceInProgress,
  }) async {
    final bootstrap = await _ref.read(appBootstrapProvider.future);
    final workoutRepository = bootstrap.workoutRepository;
    final today = DateTime.now();
    final existing = await workoutRepository.getSessionForPlanDayAndDate(
      planDayId: dayId,
      sessionDate: today,
    );
    if (existing != null) {
      if (forceInProgress && existing.sessionStatus != WorkoutSessionStatus.inProgress) {
        final updated = existing.copyWith(
          sessionStatus: WorkoutSessionStatus.inProgress,
          updatedAt: today,
        );
        await workoutRepository.saveWorkoutSession(updated);
        return updated;
      }
      return existing;
    }

    final created = WorkoutSession(
      id: AppIdFactory.next('session'),
      planDayId: dayId,
      sessionDate: today,
      sessionStatus: forceInProgress
          ? WorkoutSessionStatus.inProgress
          : WorkoutSessionStatus.pending,
      createdAt: today,
      updatedAt: today,
    );
    await workoutRepository.saveWorkoutSession(created);
    return created;
  }

  StrengthSetLog? _findStrengthLog(
    List<StrengthSetLog> logs,
    String exerciseId,
    int setIndex,
  ) {
    for (final log in logs) {
      if (log.exerciseTemplateId == exerciseId && log.setIndex == setIndex) {
        return log;
      }
    }
    return null;
  }

  CardioLog? _findCardioLog(List<CardioLog> logs, String exerciseId) {
    for (final log in logs) {
      if (log.exerciseTemplateId == exerciseId) {
        return log;
      }
    }
    return null;
  }

  void _bumpSchedule() {
    _ref.read(weekRefreshTickProvider.notifier).update((state) => state + 1);
  }

  void _bumpWorkout() {
    _ref.read(workoutRefreshTickProvider.notifier).update((state) => state + 1);
  }
}

class DayDetailState {
  const DayDetailState({
    required this.day,
    required this.todaySession,
    required this.exercises,
  });

  final PlanDay day;
  final WorkoutSession? todaySession;
  final List<DayExerciseDetail> exercises;

  bool get isTrainingDay => day.isTrainingDay;
  bool get isRestDay => day.isRestDay;
  bool get hasExercises => exercises.isNotEmpty;
}

class DayExerciseDetail {
  const DayExerciseDetail._({
    required this.exercise,
    required this.type,
    this.strengthTemplate,
    this.cardioTemplate,
    this.lastUsedWeight,
    this.strengthLogs = const [],
    this.cardioLog,
  });

  factory DayExerciseDetail.strength({
    required ExerciseTemplate exercise,
    required StrengthTemplate strengthTemplate,
    required List<StrengthSetLog> strengthLogs,
    double? lastUsedWeight,
  }) {
    return DayExerciseDetail._(
      exercise: exercise,
      type: ExerciseType.strength,
      strengthTemplate: strengthTemplate,
      strengthLogs: strengthLogs,
      lastUsedWeight: lastUsedWeight,
    );
  }

  factory DayExerciseDetail.cardio({
    required ExerciseTemplate exercise,
    required CardioTemplate cardioTemplate,
    CardioLog? cardioLog,
  }) {
    return DayExerciseDetail._(
      exercise: exercise,
      type: ExerciseType.cardio,
      cardioTemplate: cardioTemplate,
      cardioLog: cardioLog,
    );
  }

  final ExerciseTemplate exercise;
  final ExerciseType type;
  final StrengthTemplate? strengthTemplate;
  final CardioTemplate? cardioTemplate;
  final double? lastUsedWeight;
  final List<StrengthSetLog> strengthLogs;
  final CardioLog? cardioLog;

  int get completedStrengthSets {
    return strengthLogs.where((item) => item.isCompleted).length;
  }
}

class StrengthSetLogDraft {
  const StrengthSetLogDraft({
    required this.isCompleted,
    this.performedReps,
    this.performedWeight,
  });

  final bool isCompleted;
  final int? performedReps;
  final double? performedWeight;
}