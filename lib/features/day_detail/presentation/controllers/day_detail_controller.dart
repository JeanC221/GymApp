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
import 'package:smartfit/core/domain/repositories/schedule_repository.dart';
import 'package:smartfit/core/domain/repositories/workout_repository.dart';
import 'package:smartfit/core/domain/rules/plan_day_rules.dart';
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

  final transferTargets = days
      .where((item) => item.id != dayId && item.isTrainingDay)
      .toList(growable: false);

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
    transferTargets: transferTargets,
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
    bool trimOverflowLogs = false,
  }) async {
    final bootstrap = await _ref.read(appBootstrapProvider.future);
    var trimmedLogs = false;

    if (targetSets < template.targetSets) {
      trimmedLogs = await _trimOverflowStrengthLogs(
        workoutRepository: bootstrap.workoutRepository,
        exerciseId: exercise.id,
        keepSets: targetSets,
        trimOverflowLogs: trimOverflowLogs,
      );
    }

    await bootstrap.scheduleRepository.saveStrengthExercise(
      exercise: exercise.copyWith(displayName: displayName.trim()),
      template: template.copyWith(
        targetSets: targetSets,
        targetReps: targetReps,
      ),
    );
    _bumpSchedule();
    if (trimmedLogs) {
      _bumpWorkout();
    }
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
    await _normalizeExerciseOrder(bootstrap.scheduleRepository, dayId);
    _bumpSchedule();
  }

  Future<void> moveExerciseUp(String exerciseId) async {
    await _moveExerciseWithinDay(exerciseId: exerciseId, offset: -1);
  }

  Future<void> moveExerciseDown(String exerciseId) async {
    await _moveExerciseWithinDay(exerciseId: exerciseId, offset: 1);
  }

  Future<void> reorderExercise({
    required String exerciseId,
    required int targetIndex,
  }) async {
    final bootstrap = await _ref.read(appBootstrapProvider.future);
    final repository = bootstrap.scheduleRepository;
    final exercises = await repository.listExercises(dayId);
    final currentIndex = exercises.indexWhere((item) => item.id == exerciseId);
    if (currentIndex == -1) {
      throw StateError('The requested exercise could not be found.');
    }
    if (targetIndex < 0 || targetIndex >= exercises.length || currentIndex == targetIndex) {
      return;
    }

    final reordered = [...exercises];
    final moved = reordered.removeAt(currentIndex);
    reordered.insert(targetIndex, moved);
    await repository.reorderExercises(dayId, reordered);
    _bumpSchedule();
  }

  Future<void> copyExerciseToDay({
    required DayExerciseDetail item,
    required String targetDayId,
  }) async {
    await _copyOrMoveExerciseToDay(
      item: item,
      targetDayId: targetDayId,
      deleteFromSource: false,
    );
  }

  Future<void> moveExerciseToDay({
    required DayExerciseDetail item,
    required String targetDayId,
  }) async {
    await _copyOrMoveExerciseToDay(
      item: item,
      targetDayId: targetDayId,
      deleteFromSource: true,
    );
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

  Future<void> _moveExerciseWithinDay({
    required String exerciseId,
    required int offset,
  }) async {
    final bootstrap = await _ref.read(appBootstrapProvider.future);
    final repository = bootstrap.scheduleRepository;
    final exercises = await repository.listExercises(dayId);
    final currentIndex = exercises.indexWhere((item) => item.id == exerciseId);
    if (currentIndex == -1) {
      throw StateError('The requested exercise could not be found.');
    }

    final nextIndex = currentIndex + offset;
    if (nextIndex < 0 || nextIndex >= exercises.length) {
      return;
    }

    final reordered = [...exercises];
    final moved = reordered.removeAt(currentIndex);
    reordered.insert(nextIndex, moved);
    await repository.reorderExercises(dayId, reordered);
    _bumpSchedule();
  }

  Future<void> _copyOrMoveExerciseToDay({
    required DayExerciseDetail item,
    required String targetDayId,
    required bool deleteFromSource,
  }) async {
    if (targetDayId == dayId) {
      throw StateError('Choose a different training day for this action.');
    }

    final bootstrap = await _ref.read(appBootstrapProvider.future);
    final scheduleRepository = bootstrap.scheduleRepository;
    final targetDay = await _loadTransferTarget(
      scheduleRepository: scheduleRepository,
      targetDayId: targetDayId,
    );
    PlanDayRules.validateCanAcceptExercises(targetDay);

    final targetExercises = await scheduleRepository.listExercises(targetDayId);
    final nextOrderIndex = _nextOrderIndex(targetExercises);

    if (deleteFromSource) {
      await scheduleRepository.deleteExercise(item.exercise.id);
    }

    if (item.type == ExerciseType.strength) {
      final exerciseId = deleteFromSource ? item.exercise.id : AppIdFactory.next('exercise');
      await scheduleRepository.saveStrengthExercise(
        exercise: item.exercise.copyWith(
          id: exerciseId,
          planDayId: targetDayId,
          orderIndex: nextOrderIndex,
        ),
        template: item.strengthTemplate!.copyWith(exerciseTemplateId: exerciseId),
      );
    } else {
      final exerciseId = deleteFromSource ? item.exercise.id : AppIdFactory.next('exercise');
      await scheduleRepository.saveCardioExercise(
        exercise: item.exercise.copyWith(
          id: exerciseId,
          planDayId: targetDayId,
          orderIndex: nextOrderIndex,
        ),
        template: item.cardioTemplate!.copyWith(exerciseTemplateId: exerciseId),
      );
    }

    if (deleteFromSource) {
      await _normalizeExerciseOrder(scheduleRepository, dayId);
    }
    await _normalizeExerciseOrder(scheduleRepository, targetDayId);
    _bumpSchedule();
  }

  Future<PlanDay> _loadTransferTarget({
    required ScheduleRepository scheduleRepository,
    required String targetDayId,
  }) async {
    final activePlan = await scheduleRepository.getActivePlan();
    if (activePlan == null) {
      throw StateError('No active plan is available.');
    }

    final days = await scheduleRepository.listCreatedDays(activePlan.id);
    for (final item in days) {
      if (item.id == targetDayId) {
        return item;
      }
    }

    throw StateError('The selected target day could not be found.');
  }

  Future<void> _normalizeExerciseOrder(
    ScheduleRepository scheduleRepository,
    String planDayId,
  ) async {
    final exercises = await scheduleRepository.listExercises(planDayId);
    var requiresNormalization = false;
    for (var index = 0; index < exercises.length; index++) {
      if (exercises[index].orderIndex != index) {
        requiresNormalization = true;
        break;
      }
    }
    if (!requiresNormalization) {
      return;
    }
    await scheduleRepository.reorderExercises(planDayId, exercises);
  }

  int _nextOrderIndex(List<ExerciseTemplate> exercises) {
    if (exercises.isEmpty) {
      return 0;
    }
    var maxOrderIndex = exercises.first.orderIndex;
    for (final exercise in exercises.skip(1)) {
      if (exercise.orderIndex > maxOrderIndex) {
        maxOrderIndex = exercise.orderIndex;
      }
    }
    return maxOrderIndex + 1;
  }

  Future<bool> _trimOverflowStrengthLogs({
    required WorkoutRepository workoutRepository,
    required String exerciseId,
    required int keepSets,
    required bool trimOverflowLogs,
  }) async {
    final session = await workoutRepository.getSessionForPlanDayAndDate(
      planDayId: dayId,
      sessionDate: DateTime.now(),
    );
    if (session == null) {
      return false;
    }

    final existingLogs = await workoutRepository.listStrengthSetLogs(session.id);
    final overflowLogs = existingLogs
        .where((item) => item.exerciseTemplateId == exerciseId && item.setIndex >= keepSets)
        .toList(growable: false);
    if (overflowLogs.isEmpty) {
      return false;
    }
    if (!trimOverflowLogs) {
      throw StrengthSetReductionConflict(
        keepSets: keepSets,
        trimmedLogCount: overflowLogs.length,
      );
    }

    final retained = existingLogs
        .where((item) => item.exerciseTemplateId != exerciseId || item.setIndex < keepSets)
        .toList(growable: false);
    await workoutRepository.deleteStrengthLogsForSession(session.id);
    if (retained.isNotEmpty) {
      await workoutRepository.saveStrengthSetLogs(retained);
    }
    return true;
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
    required this.transferTargets,
  });

  final PlanDay day;
  final WorkoutSession? todaySession;
  final List<DayExerciseDetail> exercises;
  final List<PlanDay> transferTargets;

  bool get isTrainingDay => day.isTrainingDay;
  bool get isRestDay => day.isRestDay;
  bool get hasExercises => exercises.isNotEmpty;
  bool get hasTransferTargets => transferTargets.isNotEmpty;
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

class StrengthSetReductionConflict implements Exception {
  const StrengthSetReductionConflict({
    required this.keepSets,
    required this.trimmedLogCount,
  });

  final int keepSets;
  final int trimmedLogCount;

  @override
  String toString() {
    return 'Reducing this exercise to $keepSets sets would remove $trimmedLogCount saved set logs from today.';
  }
}