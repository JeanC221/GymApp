import 'package:isar/isar.dart';
import 'package:smartfit/core/data/isar/collections/cardio_log_record.dart';
import 'package:smartfit/core/data/isar/collections/strength_set_log_record.dart';
import 'package:smartfit/core/data/isar/collections/workout_session_record.dart';
import 'package:smartfit/core/data/mappers/isar_domain_mappers.dart';
import 'package:smartfit/core/domain/entities/cardio_log.dart';
import 'package:smartfit/core/domain/entities/strength_set_log.dart';
import 'package:smartfit/core/domain/entities/workout_session.dart';
import 'package:smartfit/core/domain/repositories/workout_repository.dart';
import 'package:smartfit/core/domain/rules/workout_session_rules.dart';
import 'package:smartfit/core/domain/services/last_used_weight_service.dart';

class IsarWorkoutRepository implements WorkoutRepository {
  IsarWorkoutRepository(this._isar);

  final Isar _isar;

  @override
  Future<WorkoutSession?> getSessionForPlanDayAndDate({
    required String planDayId,
    required DateTime sessionDate,
  }) async {
    final normalizedDate = WorkoutSessionRules.normalizeSessionDate(sessionDate);
    final sessions = await listSessionsForPlanDay(planDayId);
    for (final session in sessions) {
      if (session.sessionDate == normalizedDate) {
        return session;
      }
    }

    return null;
  }

  @override
  Future<List<WorkoutSession>> listSessionsForPlanDay(String planDayId) async {
    final records = await _isar.workoutSessionRecords
        .filter()
        .planDayIdEqualTo(planDayId)
        .findAll();

    records.sort((left, right) => right.sessionDate.compareTo(left.sessionDate));
    return records.map((record) => record.toDomain()).toList(growable: false);
  }

  @override
  Future<void> saveWorkoutSession(WorkoutSession session) async {
    final existing = await _findWorkoutSessionRecord(session.id);
    final duplicate = await getSessionForPlanDayAndDate(
      planDayId: session.planDayId,
      sessionDate: session.sessionDate,
    );
    if (duplicate != null && duplicate.id != session.id) {
      throw StateError('There is already a workout session persisted for this plan day and date.');
    }

    await _isar.writeTxn(() async {
      await _isar.workoutSessionRecords.put(session.toRecord(existing));
    });
  }

  @override
  Future<void> deleteWorkoutSession(String sessionId) async {
    final record = await _findWorkoutSessionRecord(sessionId);
    if (record == null) {
      return;
    }

    await _isar.writeTxn(() async {
      await _deleteStrengthLogsForSessionInternal(sessionId);
      await _deleteCardioLogsForSessionInternal(sessionId);
      await _isar.workoutSessionRecords.delete(record.isarId);
    });
  }

  @override
  Future<List<StrengthSetLog>> listStrengthSetLogs(String workoutSessionId) async {
    final records = await _isar.strengthSetLogRecords
        .filter()
        .workoutSessionIdEqualTo(workoutSessionId)
        .findAll();

    records.sort((left, right) => left.setIndex.compareTo(right.setIndex));
    return records.map((record) => record.toDomain()).toList(growable: false);
  }

  @override
  Future<void> saveStrengthSetLog(StrengthSetLog log) async {
    final existing = await _findStrengthSetLogRecord(log.id);
    await _isar.writeTxn(() async {
      await _isar.strengthSetLogRecords.put(log.toRecord(existing));
    });
  }

  @override
  Future<void> saveStrengthSetLogs(List<StrengthSetLog> logs) async {
    await _isar.writeTxn(() async {
      final records = <StrengthSetLogRecord>[];
      for (final log in logs) {
        final existing = await _findStrengthSetLogRecord(log.id);
        records.add(log.toRecord(existing));
      }
      await _isar.strengthSetLogRecords.putAll(records);
    });
  }

  @override
  Future<void> deleteStrengthLogsForSession(String workoutSessionId) async {
    await _isar.writeTxn(() async {
      await _deleteStrengthLogsForSessionInternal(workoutSessionId);
    });
  }

  @override
  Future<List<CardioLog>> listCardioLogs(String workoutSessionId) async {
    final records = await _isar.cardioLogRecords
        .filter()
        .workoutSessionIdEqualTo(workoutSessionId)
        .findAll();
    return records.map((record) => record.toDomain()).toList(growable: false);
  }

  @override
  Future<void> saveCardioLog(CardioLog log) async {
    final existing = await _findCardioLogRecord(log.id);
    await _isar.writeTxn(() async {
      await _isar.cardioLogRecords.put(log.toRecord(existing));
    });
  }

  @override
  Future<void> saveCardioLogs(List<CardioLog> logs) async {
    await _isar.writeTxn(() async {
      final records = <CardioLogRecord>[];
      for (final log in logs) {
        final existing = await _findCardioLogRecord(log.id);
        records.add(log.toRecord(existing));
      }
      await _isar.cardioLogRecords.putAll(records);
    });
  }

  @override
  Future<void> deleteCardioLogsForSession(String workoutSessionId) async {
    await _isar.writeTxn(() async {
      await _deleteCardioLogsForSessionInternal(workoutSessionId);
    });
  }

  @override
  Future<StrengthSetLog?> getLastUsedWeight(String exerciseTemplateId) async {
    final records = await _isar.strengthSetLogRecords
        .filter()
        .exerciseTemplateIdEqualTo(exerciseTemplateId)
        .findAll();
    final logs = records.map((record) => record.toDomain()).toList(growable: false);
    return LastUsedWeightService.latestCompletedWeightedSet(logs, exerciseTemplateId);
  }

  Future<WorkoutSessionRecord?> _findWorkoutSessionRecord(String id) {
    return _isar.workoutSessionRecords.filter().idEqualTo(id).findFirst();
  }

  Future<StrengthSetLogRecord?> _findStrengthSetLogRecord(String id) {
    return _isar.strengthSetLogRecords.filter().idEqualTo(id).findFirst();
  }

  Future<CardioLogRecord?> _findCardioLogRecord(String id) {
    return _isar.cardioLogRecords.filter().idEqualTo(id).findFirst();
  }

  Future<void> _deleteStrengthLogsForSessionInternal(String workoutSessionId) async {
    final records = await _isar.strengthSetLogRecords
        .filter()
        .workoutSessionIdEqualTo(workoutSessionId)
        .findAll();
    for (final record in records) {
      await _isar.strengthSetLogRecords.delete(record.isarId);
    }
  }

  Future<void> _deleteCardioLogsForSessionInternal(String workoutSessionId) async {
    final records = await _isar.cardioLogRecords
        .filter()
        .workoutSessionIdEqualTo(workoutSessionId)
        .findAll();
    for (final record in records) {
      await _isar.cardioLogRecords.delete(record.isarId);
    }
  }
}