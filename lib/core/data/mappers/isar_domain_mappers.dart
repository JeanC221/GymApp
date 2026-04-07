import 'package:smartfit/core/data/isar/collections/app_settings_record.dart';
import 'package:smartfit/core/data/isar/collections/cardio_log_record.dart';
import 'package:smartfit/core/data/isar/collections/cardio_template_record.dart';
import 'package:smartfit/core/data/isar/collections/exercise_template_record.dart';
import 'package:smartfit/core/data/isar/collections/plan_day_record.dart';
import 'package:smartfit/core/data/isar/collections/strength_set_log_record.dart';
import 'package:smartfit/core/data/isar/collections/strength_template_record.dart';
import 'package:smartfit/core/data/isar/collections/weekly_plan_record.dart';
import 'package:smartfit/core/data/isar/collections/workout_session_record.dart';
import 'package:smartfit/core/domain/entities/app_settings.dart';
import 'package:smartfit/core/domain/entities/cardio_log.dart';
import 'package:smartfit/core/domain/entities/cardio_template.dart';
import 'package:smartfit/core/domain/entities/exercise_template.dart';
import 'package:smartfit/core/domain/entities/plan_day.dart';
import 'package:smartfit/core/domain/entities/strength_set_log.dart';
import 'package:smartfit/core/domain/entities/strength_template.dart';
import 'package:smartfit/core/domain/entities/weekly_plan.dart';
import 'package:smartfit/core/domain/entities/workout_session.dart';
import 'package:smartfit/core/domain/rules/workout_session_rules.dart';

extension WeeklyPlanRecordMapper on WeeklyPlanRecord {
  WeeklyPlan toDomain() {
    return WeeklyPlan(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isActive: isActive,
    );
  }
}

extension WeeklyPlanMapper on WeeklyPlan {
  WeeklyPlanRecord toRecord([WeeklyPlanRecord? existing]) {
    final record = existing ?? WeeklyPlanRecord();
    record.id = id;
    record.createdAt = createdAt;
    record.updatedAt = updatedAt;
    record.isActive = isActive;
    return record;
  }
}

extension PlanDayRecordMapper on PlanDayRecord {
  PlanDay toDomain() {
    return PlanDay(
      id: id,
      weeklyPlanId: weeklyPlanId,
      weekday: weekday,
      type: type,
      routineName: routineName,
      orderIndex: orderIndex,
    );
  }
}

extension PlanDayMapper on PlanDay {
  PlanDayRecord toRecord([PlanDayRecord? existing]) {
    final record = existing ?? PlanDayRecord();
    record.id = id;
    record.weeklyPlanId = weeklyPlanId;
    record.weekday = weekday;
    record.type = type;
    record.routineName = routineName;
    record.orderIndex = orderIndex;
    return record;
  }
}

extension ExerciseTemplateRecordMapper on ExerciseTemplateRecord {
  ExerciseTemplate toDomain() {
    return ExerciseTemplate(
      id: id,
      planDayId: planDayId,
      type: type,
      orderIndex: orderIndex,
      displayName: displayName,
    );
  }
}

extension ExerciseTemplateMapper on ExerciseTemplate {
  ExerciseTemplateRecord toRecord([ExerciseTemplateRecord? existing]) {
    final record = existing ?? ExerciseTemplateRecord();
    record.id = id;
    record.planDayId = planDayId;
    record.type = type;
    record.orderIndex = orderIndex;
    record.displayName = displayName;
    return record;
  }
}

extension StrengthTemplateRecordMapper on StrengthTemplateRecord {
  StrengthTemplate toDomain() {
    return StrengthTemplate(
      exerciseTemplateId: exerciseTemplateId,
      targetSets: targetSets,
      targetReps: targetReps,
    );
  }
}

extension StrengthTemplateMapper on StrengthTemplate {
  StrengthTemplateRecord toRecord([StrengthTemplateRecord? existing]) {
    final record = existing ?? StrengthTemplateRecord();
    record.exerciseTemplateId = exerciseTemplateId;
    record.targetSets = targetSets;
    record.targetReps = targetReps;
    return record;
  }
}

extension CardioTemplateRecordMapper on CardioTemplateRecord {
  CardioTemplate toDomain() {
    return CardioTemplate(
      exerciseTemplateId: exerciseTemplateId,
      cardioType: cardioType,
      defaultDurationMinutes: defaultDurationMinutes,
      defaultIncline: defaultIncline,
    );
  }
}

extension CardioTemplateMapper on CardioTemplate {
  CardioTemplateRecord toRecord([CardioTemplateRecord? existing]) {
    final record = existing ?? CardioTemplateRecord();
    record.exerciseTemplateId = exerciseTemplateId;
    record.cardioType = cardioType;
    record.defaultDurationMinutes = defaultDurationMinutes;
    record.defaultIncline = defaultIncline;
    return record;
  }
}

extension WorkoutSessionRecordMapper on WorkoutSessionRecord {
  WorkoutSession toDomain() {
    return WorkoutSession(
      id: id,
      planDayId: planDayId,
      sessionDate: sessionDate,
      sessionStatus: sessionStatus,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension WorkoutSessionMapper on WorkoutSession {
  WorkoutSessionRecord toRecord([WorkoutSessionRecord? existing]) {
    final record = existing ?? WorkoutSessionRecord();
    record.id = id;
    record.planDayId = planDayId;
    record.sessionDate = WorkoutSessionRules.normalizeSessionDate(sessionDate);
    record.sessionStatus = sessionStatus;
    record.createdAt = createdAt;
    record.updatedAt = updatedAt;
    return record;
  }
}

extension StrengthSetLogRecordMapper on StrengthSetLogRecord {
  StrengthSetLog toDomain() {
    return StrengthSetLog(
      id: id,
      workoutSessionId: workoutSessionId,
      exerciseTemplateId: exerciseTemplateId,
      setIndex: setIndex,
      performedReps: performedReps,
      performedWeight: performedWeight,
      isCompleted: isCompleted,
      completedAt: completedAt,
    );
  }
}

extension StrengthSetLogMapper on StrengthSetLog {
  StrengthSetLogRecord toRecord([StrengthSetLogRecord? existing]) {
    final record = existing ?? StrengthSetLogRecord();
    record.id = id;
    record.workoutSessionId = workoutSessionId;
    record.exerciseTemplateId = exerciseTemplateId;
    record.setIndex = setIndex;
    record.performedReps = performedReps;
    record.performedWeight = performedWeight;
    record.isCompleted = isCompleted;
    record.completedAt = completedAt;
    return record;
  }
}

extension CardioLogRecordMapper on CardioLogRecord {
  CardioLog toDomain() {
    return CardioLog(
      id: id,
      workoutSessionId: workoutSessionId,
      exerciseTemplateId: exerciseTemplateId,
      source: source,
      cardioType: cardioType,
      durationMinutes: durationMinutes,
      incline: incline,
      distance: distance,
      calories: calories,
      averageHeartRate: averageHeartRate,
    );
  }
}

extension CardioLogMapper on CardioLog {
  CardioLogRecord toRecord([CardioLogRecord? existing]) {
    final record = existing ?? CardioLogRecord();
    record.id = id;
    record.workoutSessionId = workoutSessionId;
    record.exerciseTemplateId = exerciseTemplateId;
    record.source = source;
    record.cardioType = cardioType;
    record.durationMinutes = durationMinutes;
    record.incline = incline;
    record.distance = distance;
    record.calories = calories;
    record.averageHeartRate = averageHeartRate;
    return record;
  }
}

extension AppSettingsRecordMapper on AppSettingsRecord {
  AppSettings toDomain() {
    return AppSettings(
      id: id,
      themeMode: themeMode,
      weightUnit: weightUnit,
      firstLaunchCompleted: firstLaunchCompleted,
      lastBackupAt: lastBackupAt,
      preferredGraphRange: preferredGraphRange,
    );
  }
}

extension AppSettingsMapper on AppSettings {
  AppSettingsRecord toRecord([AppSettingsRecord? existing]) {
    final record = existing ?? AppSettingsRecord();
    record.id = id;
    record.themeMode = themeMode;
    record.weightUnit = weightUnit;
    record.firstLaunchCompleted = firstLaunchCompleted;
    record.lastBackupAt = lastBackupAt;
    record.preferredGraphRange = preferredGraphRange;
    return record;
  }
}