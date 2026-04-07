import 'package:isar/isar.dart';
import 'package:smartfit/core/data/isar/collections/app_settings_record.dart';
import 'package:smartfit/core/data/isar/collections/cardio_log_record.dart';
import 'package:smartfit/core/data/isar/collections/cardio_template_record.dart';
import 'package:smartfit/core/data/isar/collections/exercise_template_record.dart';
import 'package:smartfit/core/data/isar/collections/plan_day_record.dart';
import 'package:smartfit/core/data/isar/collections/strength_set_log_record.dart';
import 'package:smartfit/core/data/isar/collections/strength_template_record.dart';
import 'package:smartfit/core/data/isar/collections/weekly_plan_record.dart';
import 'package:smartfit/core/data/isar/collections/workout_session_record.dart';
import 'package:smartfit/core/data/mappers/isar_domain_mappers.dart';

class SmartFitExportService {
  SmartFitExportService(this._isar);

  final Isar _isar;

  Future<Map<String, dynamic>> exportSnapshot() async {
    final weeklyPlans = (await _isar.weeklyPlanRecords.where().findAll())
        .map((record) => record.toDomain())
        .toList(growable: false);
    final planDays = (await _isar.planDayRecords.where().findAll())
        .map((record) => record.toDomain())
        .toList(growable: false);
    final exercises = (await _isar.exerciseTemplateRecords.where().findAll())
        .map((record) => record.toDomain())
        .toList(growable: false);
    final strengthTemplates = (await _isar.strengthTemplateRecords.where().findAll())
        .map((record) => record.toDomain())
        .toList(growable: false);
    final cardioTemplates = (await _isar.cardioTemplateRecords.where().findAll())
        .map((record) => record.toDomain())
        .toList(growable: false);
    final sessions = (await _isar.workoutSessionRecords.where().findAll())
        .map((record) => record.toDomain())
        .toList(growable: false);
    final strengthLogs = (await _isar.strengthSetLogRecords.where().findAll())
        .map((record) => record.toDomain())
        .toList(growable: false);
    final cardioLogs = (await _isar.cardioLogRecords.where().findAll())
        .map((record) => record.toDomain())
        .toList(growable: false);
    final settings = (await _isar.appSettingsRecords.where().findFirst())?.toDomain();

    return {
      'schemaVersion': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'weeklyPlans': weeklyPlans
          .map(
            (plan) => {
              'id': plan.id,
              'createdAt': plan.createdAt.toIso8601String(),
              'updatedAt': plan.updatedAt.toIso8601String(),
              'isActive': plan.isActive,
            },
          )
          .toList(growable: false),
      'planDays': planDays
          .map(
            (day) => {
              'id': day.id,
              'weeklyPlanId': day.weeklyPlanId,
              'weekday': day.weekday.name,
              'type': day.type.name,
              'routineName': day.routineName,
              'orderIndex': day.orderIndex,
            },
          )
          .toList(growable: false),
      'exerciseTemplates': exercises
          .map(
            (exercise) => {
              'id': exercise.id,
              'planDayId': exercise.planDayId,
              'type': exercise.type.name,
              'orderIndex': exercise.orderIndex,
              'displayName': exercise.displayName,
            },
          )
          .toList(growable: false),
      'strengthTemplates': strengthTemplates
          .map(
            (template) => {
              'exerciseTemplateId': template.exerciseTemplateId,
              'targetSets': template.targetSets,
              'targetReps': template.targetReps,
            },
          )
          .toList(growable: false),
      'cardioTemplates': cardioTemplates
          .map(
            (template) => {
              'exerciseTemplateId': template.exerciseTemplateId,
              'cardioType': template.cardioType,
              'defaultDurationMinutes': template.defaultDurationMinutes,
              'defaultIncline': template.defaultIncline,
            },
          )
          .toList(growable: false),
      'workoutSessions': sessions
          .map(
            (session) => {
              'id': session.id,
              'planDayId': session.planDayId,
              'sessionDate': session.sessionDate.toIso8601String(),
              'sessionStatus': session.sessionStatus.name,
              'createdAt': session.createdAt.toIso8601String(),
              'updatedAt': session.updatedAt.toIso8601String(),
            },
          )
          .toList(growable: false),
      'strengthSetLogs': strengthLogs
          .map(
            (log) => {
              'id': log.id,
              'workoutSessionId': log.workoutSessionId,
              'exerciseTemplateId': log.exerciseTemplateId,
              'setIndex': log.setIndex,
              'performedReps': log.performedReps,
              'performedWeight': log.performedWeight,
              'isCompleted': log.isCompleted,
              'completedAt': log.completedAt?.toIso8601String(),
            },
          )
          .toList(growable: false),
      'cardioLogs': cardioLogs
          .map(
            (log) => {
              'id': log.id,
              'workoutSessionId': log.workoutSessionId,
              'exerciseTemplateId': log.exerciseTemplateId,
              'source': log.source.name,
              'cardioType': log.cardioType,
              'durationMinutes': log.durationMinutes,
              'incline': log.incline,
              'distance': log.distance,
              'calories': log.calories,
              'averageHeartRate': log.averageHeartRate,
            },
          )
          .toList(growable: false),
      'settings': settings == null
          ? null
          : {
              'id': settings.id,
              'themeMode': settings.themeMode.name,
              'weightUnit': settings.weightUnit.name,
              'firstLaunchCompleted': settings.firstLaunchCompleted,
              'lastBackupAt': settings.lastBackupAt?.toIso8601String(),
              'preferredGraphRange': settings.preferredGraphRange.name,
            },
    };
  }
}