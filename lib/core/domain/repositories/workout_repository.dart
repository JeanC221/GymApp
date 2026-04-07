import 'package:smartfit/core/domain/entities/cardio_log.dart';
import 'package:smartfit/core/domain/entities/strength_set_log.dart';
import 'package:smartfit/core/domain/entities/workout_session.dart';

abstract interface class WorkoutRepository {
  Future<WorkoutSession?> getSessionForPlanDayAndDate({
    required String planDayId,
    required DateTime sessionDate,
  });

  Future<List<WorkoutSession>> listSessionsForPlanDay(String planDayId);

  Future<void> saveWorkoutSession(WorkoutSession session);

  Future<void> deleteWorkoutSession(String sessionId);

  Future<List<StrengthSetLog>> listStrengthSetLogs(String workoutSessionId);

  Future<void> saveStrengthSetLog(StrengthSetLog log);

  Future<void> saveStrengthSetLogs(List<StrengthSetLog> logs);

  Future<void> deleteStrengthLogsForSession(String workoutSessionId);

  Future<List<CardioLog>> listCardioLogs(String workoutSessionId);

  Future<void> saveCardioLog(CardioLog log);

  Future<void> saveCardioLogs(List<CardioLog> logs);

  Future<void> deleteCardioLogsForSession(String workoutSessionId);

  Future<StrengthSetLog?> getLastUsedWeight(String exerciseTemplateId);
}