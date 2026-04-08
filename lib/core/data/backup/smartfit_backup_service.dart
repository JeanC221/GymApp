import 'dart:convert';
import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smartfit/core/data/isar/collections/app_settings_record.dart';
import 'package:smartfit/core/data/isar/collections/cardio_log_record.dart';
import 'package:smartfit/core/data/isar/collections/cardio_template_record.dart';
import 'package:smartfit/core/data/isar/collections/exercise_template_record.dart';
import 'package:smartfit/core/data/isar/collections/plan_day_record.dart';
import 'package:smartfit/core/data/isar/collections/strength_set_log_record.dart';
import 'package:smartfit/core/data/isar/collections/strength_template_record.dart';
import 'package:smartfit/core/data/isar/collections/weekly_plan_record.dart';
import 'package:smartfit/core/data/isar/collections/workout_session_record.dart';
import 'package:smartfit/core/data/export/smartfit_export_service.dart';
import 'package:smartfit/core/data/mappers/isar_domain_mappers.dart';
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

class SmartFitBackupService {
  SmartFitBackupService(this._isar) : _exportService = SmartFitExportService(_isar);

  static const int currentSchemaVersion = 1;

  final Isar _isar;
  final SmartFitExportService _exportService;

  Future<Map<String, dynamic>> exportSnapshot() {
    return _exportService.exportSnapshot();
  }

  Future<File> exportBackupFile() async {
    final snapshot = await exportSnapshot();
    final directory = await getTemporaryDirectory();
    final timestamp = DateTime.now();
    final file = File(
      '${directory.path}${Platform.pathSeparator}smartfit-backup-${_timestampLabel(timestamp)}.json',
    );
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(snapshot));
    return file;
  }

  Future<void> importBackupFile(String filePath) async {
    final jsonText = await File(filePath).readAsString();
    await importJsonString(jsonText);
  }

  Future<void> importJsonString(String jsonText) async {
    final decoded = jsonDecode(jsonText);
    if (decoded is! Map) {
      throw const SmartFitBackupException('Backup file is not a valid JSON object.');
    }
    await importSnapshot(Map<String, dynamic>.from(decoded));
  }

  Future<void> importSnapshot(Map<String, dynamic> snapshot) async {
    final schemaVersion = snapshot['schemaVersion'];
    if (schemaVersion is! num || schemaVersion.toInt() != currentSchemaVersion) {
      throw SmartFitBackupException(
        'Unsupported backup schema version: ${snapshot['schemaVersion']}.',
      );
    }

    final weeklyPlans = _mapList(snapshot['weeklyPlans'], _weeklyPlanFromJson);
    final planDays = _mapList(snapshot['planDays'], _planDayFromJson);
    final exerciseTemplates = _mapList(
      snapshot['exerciseTemplates'],
      _exerciseTemplateFromJson,
    );
    final strengthTemplates = _mapList(
      snapshot['strengthTemplates'],
      _strengthTemplateFromJson,
    );
    final cardioTemplates = _mapList(
      snapshot['cardioTemplates'],
      _cardioTemplateFromJson,
    );
    final workoutSessions = _mapList(
      snapshot['workoutSessions'],
      _workoutSessionFromJson,
    );
    final strengthLogs = _mapList(snapshot['strengthSetLogs'], _strengthSetLogFromJson);
    final cardioLogs = _mapList(snapshot['cardioLogs'], _cardioLogFromJson);
    final settings = _mapSingle(snapshot['settings'], _appSettingsFromJson);

    await _isar.writeTxn(() async {
      await _isar.cardioLogRecords.clear();
      await _isar.strengthSetLogRecords.clear();
      await _isar.workoutSessionRecords.clear();
      await _isar.cardioTemplateRecords.clear();
      await _isar.strengthTemplateRecords.clear();
      await _isar.exerciseTemplateRecords.clear();
      await _isar.planDayRecords.clear();
      await _isar.weeklyPlanRecords.clear();
      await _isar.appSettingsRecords.clear();

      if (weeklyPlans.isNotEmpty) {
        await _isar.weeklyPlanRecords.putAll(
          weeklyPlans.map((item) => item.toRecord()).toList(growable: false),
        );
      }
      if (planDays.isNotEmpty) {
        await _isar.planDayRecords.putAll(
          planDays.map((item) => item.toRecord()).toList(growable: false),
        );
      }
      if (exerciseTemplates.isNotEmpty) {
        await _isar.exerciseTemplateRecords.putAll(
          exerciseTemplates.map((item) => item.toRecord()).toList(growable: false),
        );
      }
      if (strengthTemplates.isNotEmpty) {
        await _isar.strengthTemplateRecords.putAll(
          strengthTemplates.map((item) => item.toRecord()).toList(growable: false),
        );
      }
      if (cardioTemplates.isNotEmpty) {
        await _isar.cardioTemplateRecords.putAll(
          cardioTemplates.map((item) => item.toRecord()).toList(growable: false),
        );
      }
      if (workoutSessions.isNotEmpty) {
        await _isar.workoutSessionRecords.putAll(
          workoutSessions.map((item) => item.toRecord()).toList(growable: false),
        );
      }
      if (strengthLogs.isNotEmpty) {
        await _isar.strengthSetLogRecords.putAll(
          strengthLogs.map((item) => item.toRecord()).toList(growable: false),
        );
      }
      if (cardioLogs.isNotEmpty) {
        await _isar.cardioLogRecords.putAll(
          cardioLogs.map((item) => item.toRecord()).toList(growable: false),
        );
      }
      if (settings != null) {
        await _isar.appSettingsRecords.put(settings.toRecord());
      }
    });
  }

  List<T> _mapList<T>(dynamic source, T Function(Map<String, dynamic> json) parser) {
    if (source == null) {
      return const [];
    }
    if (source is! List) {
      throw const SmartFitBackupException('Backup payload contains an invalid list value.');
    }

    return source.map((item) {
      if (item is! Map) {
        throw const SmartFitBackupException('Backup payload contains an invalid entry.');
      }
      return parser(Map<String, dynamic>.from(item));
    }).toList(growable: false);
  }

  T? _mapSingle<T>(dynamic source, T Function(Map<String, dynamic> json) parser) {
    if (source == null) {
      return null;
    }
    if (source is! Map) {
      throw const SmartFitBackupException('Backup payload contains an invalid object value.');
    }
    return parser(Map<String, dynamic>.from(source));
  }

  WeeklyPlan _weeklyPlanFromJson(Map<String, dynamic> json) {
    return WeeklyPlan(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool,
    );
  }

  PlanDay _planDayFromJson(Map<String, dynamic> json) {
    return PlanDay(
      id: json['id'] as String,
      weeklyPlanId: json['weeklyPlanId'] as String,
      weekday: Weekday.values.byName(json['weekday'] as String),
      type: PlanDayType.values.byName(json['type'] as String),
      routineName: json['routineName'] as String?,
      orderIndex: (json['orderIndex'] as num).toInt(),
    );
  }

  ExerciseTemplate _exerciseTemplateFromJson(Map<String, dynamic> json) {
    return ExerciseTemplate(
      id: json['id'] as String,
      planDayId: json['planDayId'] as String,
      type: ExerciseType.values.byName(json['type'] as String),
      orderIndex: (json['orderIndex'] as num).toInt(),
      displayName: json['displayName'] as String,
    );
  }

  StrengthTemplate _strengthTemplateFromJson(Map<String, dynamic> json) {
    return StrengthTemplate(
      exerciseTemplateId: json['exerciseTemplateId'] as String,
      targetSets: (json['targetSets'] as num).toInt(),
      targetReps: (json['targetReps'] as num).toInt(),
    );
  }

  CardioTemplate _cardioTemplateFromJson(Map<String, dynamic> json) {
    return CardioTemplate(
      exerciseTemplateId: json['exerciseTemplateId'] as String,
      cardioType: json['cardioType'] as String,
      defaultDurationMinutes: (json['defaultDurationMinutes'] as num).toInt(),
      defaultIncline: (json['defaultIncline'] as num?)?.toDouble(),
    );
  }

  WorkoutSession _workoutSessionFromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      id: json['id'] as String,
      planDayId: json['planDayId'] as String,
      sessionDate: DateTime.parse(json['sessionDate'] as String),
      sessionStatus: WorkoutSessionStatus.values.byName(json['sessionStatus'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  StrengthSetLog _strengthSetLogFromJson(Map<String, dynamic> json) {
    return StrengthSetLog(
      id: json['id'] as String,
      workoutSessionId: json['workoutSessionId'] as String,
      exerciseTemplateId: json['exerciseTemplateId'] as String,
      setIndex: (json['setIndex'] as num).toInt(),
      performedReps: (json['performedReps'] as num?)?.toInt(),
      performedWeight: (json['performedWeight'] as num?)?.toDouble(),
      isCompleted: json['isCompleted'] as bool,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );
  }

  CardioLog _cardioLogFromJson(Map<String, dynamic> json) {
    return CardioLog(
      id: json['id'] as String,
      workoutSessionId: json['workoutSessionId'] as String,
      exerciseTemplateId: json['exerciseTemplateId'] as String,
      source: CardioSource.values.byName(json['source'] as String),
      cardioType: json['cardioType'] as String,
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      incline: (json['incline'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
      calories: (json['calories'] as num?)?.toInt(),
      averageHeartRate: (json['averageHeartRate'] as num?)?.toInt(),
    );
  }

  AppSettings _appSettingsFromJson(Map<String, dynamic> json) {
    return AppSettings(
      id: json['id'] as String,
      themeMode: AppThemePreference.values.byName(json['themeMode'] as String),
      weightUnit: WeightUnit.values.byName(json['weightUnit'] as String),
      firstLaunchCompleted: json['firstLaunchCompleted'] as bool,
      lastBackupAt: json['lastBackupAt'] == null
          ? null
          : DateTime.parse(json['lastBackupAt'] as String),
      preferredGraphRange: ProgressRange.values.byName(
        json['preferredGraphRange'] as String,
      ),
    );
  }

  String _timestampLabel(DateTime dateTime) {
    return '${dateTime.year}${_pad(dateTime.month)}${_pad(dateTime.day)}_${_pad(dateTime.hour)}${_pad(dateTime.minute)}${_pad(dateTime.second)}';
  }

  String _pad(int value) => value.toString().padLeft(2, '0');
}

class SmartFitBackupException implements Exception {
  const SmartFitBackupException(this.message);

  final String message;

  @override
  String toString() => message;
}