import 'package:isar/isar.dart';
import 'package:smartfit/core/data/isar/collections/cardio_template_record.dart';
import 'package:smartfit/core/data/isar/collections/exercise_template_record.dart';
import 'package:smartfit/core/data/isar/collections/plan_day_record.dart';
import 'package:smartfit/core/data/isar/collections/cardio_log_record.dart';
import 'package:smartfit/core/data/isar/collections/strength_set_log_record.dart';
import 'package:smartfit/core/data/isar/collections/strength_template_record.dart';
import 'package:smartfit/core/data/isar/collections/weekly_plan_record.dart';
import 'package:smartfit/core/data/isar/collections/workout_session_record.dart';
import 'package:smartfit/core/data/mappers/isar_domain_mappers.dart';
import 'package:smartfit/core/domain/entities/cardio_template.dart';
import 'package:smartfit/core/domain/entities/exercise_template.dart';
import 'package:smartfit/core/domain/entities/plan_day.dart';
import 'package:smartfit/core/domain/entities/strength_template.dart';
import 'package:smartfit/core/domain/entities/weekly_plan.dart';
import 'package:smartfit/core/domain/enums/exercise_type.dart';
import 'package:smartfit/core/domain/enums/weekday.dart';
import 'package:smartfit/core/domain/repositories/schedule_repository.dart';

class IsarScheduleRepository implements ScheduleRepository {
  IsarScheduleRepository(this._isar);

  final Isar _isar;

  @override
  Future<WeeklyPlan?> getActivePlan() async {
    final plans = await _isar.weeklyPlanRecords.where().findAll();
    WeeklyPlanRecord? activeRecord;
    for (final plan in plans) {
      if (plan.isActive) {
        activeRecord = plan;
        break;
      }
    }

    return activeRecord?.toDomain();
  }

  @override
  Future<void> saveWeeklyPlan(WeeklyPlan plan) async {
    final existing = await _findWeeklyPlanRecord(plan.id);
    await _isar.writeTxn(() async {
      if (plan.isActive) {
        final activePlans = await _isar.weeklyPlanRecords.where().findAll();
        for (final activePlan in activePlans.where((item) => item.id != plan.id && item.isActive)) {
          activePlan.isActive = false;
        }
        await _isar.weeklyPlanRecords.putAll(activePlans);
      }

      await _isar.weeklyPlanRecords.put(plan.toRecord(existing));
    });
  }

  @override
  Future<List<PlanDay>> listPlanDays(String weeklyPlanId) async {
    final records = await _isar.planDayRecords
        .filter()
        .weeklyPlanIdEqualTo(weeklyPlanId)
        .findAll();

    records.sort((left, right) => left.orderIndex.compareTo(right.orderIndex));
    return records.map((record) => record.toDomain()).toList(growable: false);
  }

  @override
  Future<List<PlanDay>> listCreatedDays(String weeklyPlanId) {
    return listPlanDays(weeklyPlanId);
  }

  @override
  Future<PlanDay?> getPlanDayForDate(DateTime date) async {
    final activePlan = await getActivePlan();
    if (activePlan == null) {
      return null;
    }

    final weekday = Weekday.values[date.weekday - 1];
    return getPlanDayByWeekday(activePlan.id, weekday);
  }

  @override
  Future<PlanDay?> getPlanDayByWeekday(String weeklyPlanId, Weekday weekday) async {
    final days = await listPlanDays(weeklyPlanId);
    for (final day in days) {
      if (day.weekday == weekday) {
        return day;
      }
    }

    return null;
  }

  @override
  Future<void> savePlanDay(PlanDay day) async {
    final currentDays = await listPlanDays(day.weeklyPlanId);
    for (final currentDay in currentDays) {
      if (currentDay.id != day.id && currentDay.weekday == day.weekday) {
        throw StateError('Weekday ${day.weekday.name} is already assigned in this weekly plan.');
      }
    }

    final existing = await _findPlanDayRecord(day.id);
    await _isar.writeTxn(() async {
      await _isar.planDayRecords.put(day.toRecord(existing));
    });
  }

  @override
  Future<void> deletePlanDay(String planDayId) async {
    final hasSessions = await _isar.workoutSessionRecords
        .filter()
        .planDayIdEqualTo(planDayId)
        .findFirst() != null;
    if (hasSessions) {
      throw StateError('Cannot delete a plan day that already has workout history.');
    }

    final planDayRecord = await _findPlanDayRecord(planDayId);
    if (planDayRecord == null) {
      return;
    }

    final exerciseRecords = await _isar.exerciseTemplateRecords
        .filter()
        .planDayIdEqualTo(planDayId)
        .findAll();

    await _isar.writeTxn(() async {
      for (final exercise in exerciseRecords) {
        await _deleteExerciseInternal(exercise.id);
      }
      await _isar.planDayRecords.delete(planDayRecord.isarId);
    });
  }

  @override
  Future<List<ExerciseTemplate>> listExercises(String planDayId) async {
    final records = await _isar.exerciseTemplateRecords
        .filter()
        .planDayIdEqualTo(planDayId)
        .findAll();

    records.sort((left, right) => left.orderIndex.compareTo(right.orderIndex));
    return records.map((record) => record.toDomain()).toList(growable: false);
  }

  @override
  Future<StrengthTemplate?> getStrengthTemplate(String exerciseTemplateId) async {
    final record = await _isar.strengthTemplateRecords
        .filter()
        .exerciseTemplateIdEqualTo(exerciseTemplateId)
        .findFirst();
    return record?.toDomain();
  }

  @override
  Future<CardioTemplate?> getCardioTemplate(String exerciseTemplateId) async {
    final record = await _isar.cardioTemplateRecords
        .filter()
        .exerciseTemplateIdEqualTo(exerciseTemplateId)
        .findFirst();
    return record?.toDomain();
  }

  @override
  Future<void> saveStrengthExercise({
    required ExerciseTemplate exercise,
    required StrengthTemplate template,
  }) async {
    if (exercise.type != ExerciseType.strength) {
      throw StateError('Strength exercise persistence requires an ExerciseType.strength template.');
    }

    final existingExercise = await _findExerciseRecord(exercise.id);
    final existingStrength = await _findStrengthTemplateRecord(template.exerciseTemplateId);
    final existingCardio = await _findCardioTemplateRecord(template.exerciseTemplateId);

    await _isar.writeTxn(() async {
      await _isar.exerciseTemplateRecords.put(exercise.toRecord(existingExercise));
      await _isar.strengthTemplateRecords.put(template.toRecord(existingStrength));
      if (existingCardio != null) {
        await _isar.cardioTemplateRecords.delete(existingCardio.isarId);
      }
    });
  }

  @override
  Future<void> saveCardioExercise({
    required ExerciseTemplate exercise,
    required CardioTemplate template,
  }) async {
    if (exercise.type != ExerciseType.cardio) {
      throw StateError('Cardio exercise persistence requires an ExerciseType.cardio template.');
    }

    final existingExercise = await _findExerciseRecord(exercise.id);
    final existingCardio = await _findCardioTemplateRecord(template.exerciseTemplateId);
    final existingStrength = await _findStrengthTemplateRecord(template.exerciseTemplateId);

    await _isar.writeTxn(() async {
      await _isar.exerciseTemplateRecords.put(exercise.toRecord(existingExercise));
      await _isar.cardioTemplateRecords.put(template.toRecord(existingCardio));
      if (existingStrength != null) {
        await _isar.strengthTemplateRecords.delete(existingStrength.isarId);
      }
    });
  }

  @override
  Future<void> deleteExercise(String exerciseTemplateId) async {
    final hasStrengthLogs = await _isar.strengthSetLogRecords
        .filter()
        .exerciseTemplateIdEqualTo(exerciseTemplateId)
        .findFirst() != null;
    final hasCardioLogs = await _isar.cardioLogRecords
        .filter()
        .exerciseTemplateIdEqualTo(exerciseTemplateId)
        .findFirst() != null;

    if (hasStrengthLogs || hasCardioLogs) {
      throw StateError('Cannot delete an exercise that already has persisted workout history.');
    }

    await _isar.writeTxn(() async {
      await _deleteExerciseInternal(exerciseTemplateId);
    });
  }

  @override
  Future<void> reorderPlanDays(List<PlanDay> orderedDays) async {
    await _isar.writeTxn(() async {
      final records = <PlanDayRecord>[];
      for (var index = 0; index < orderedDays.length; index++) {
        final day = orderedDays[index].copyWith(orderIndex: index);
        final existing = await _findPlanDayRecord(day.id);
        records.add(day.toRecord(existing));
      }
      await _isar.planDayRecords.putAll(records);
    });
  }

  @override
  Future<void> reorderExercises(
    String planDayId,
    List<ExerciseTemplate> orderedExercises,
  ) async {
    for (final exercise in orderedExercises) {
      if (exercise.planDayId != planDayId) {
        throw StateError('All reordered exercises must belong to the same plan day.');
      }
    }

    await _isar.writeTxn(() async {
      final records = <ExerciseTemplateRecord>[];
      for (var index = 0; index < orderedExercises.length; index++) {
        final exercise = orderedExercises[index].copyWith(orderIndex: index);
        final existing = await _findExerciseRecord(exercise.id);
        records.add(exercise.toRecord(existing));
      }
      await _isar.exerciseTemplateRecords.putAll(records);
    });
  }

  Future<WeeklyPlanRecord?> _findWeeklyPlanRecord(String id) {
    return _isar.weeklyPlanRecords.filter().idEqualTo(id).findFirst();
  }

  Future<PlanDayRecord?> _findPlanDayRecord(String id) {
    return _isar.planDayRecords.filter().idEqualTo(id).findFirst();
  }

  Future<ExerciseTemplateRecord?> _findExerciseRecord(String id) {
    return _isar.exerciseTemplateRecords.filter().idEqualTo(id).findFirst();
  }

  Future<StrengthTemplateRecord?> _findStrengthTemplateRecord(String exerciseTemplateId) {
    return _isar.strengthTemplateRecords
        .filter()
        .exerciseTemplateIdEqualTo(exerciseTemplateId)
        .findFirst();
  }

  Future<CardioTemplateRecord?> _findCardioTemplateRecord(String exerciseTemplateId) {
    return _isar.cardioTemplateRecords
        .filter()
        .exerciseTemplateIdEqualTo(exerciseTemplateId)
        .findFirst();
  }

  Future<void> _deleteExerciseInternal(String exerciseTemplateId) async {
    final exercise = await _findExerciseRecord(exerciseTemplateId);
    final strength = await _findStrengthTemplateRecord(exerciseTemplateId);
    final cardio = await _findCardioTemplateRecord(exerciseTemplateId);

    if (strength != null) {
      await _isar.strengthTemplateRecords.delete(strength.isarId);
    }
    if (cardio != null) {
      await _isar.cardioTemplateRecords.delete(cardio.isarId);
    }
    if (exercise != null) {
      await _isar.exerciseTemplateRecords.delete(exercise.isarId);
    }
  }
}