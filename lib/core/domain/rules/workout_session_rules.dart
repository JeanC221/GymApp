import 'package:smartfit/core/domain/entities/workout_session.dart';

class WorkoutSessionRules {
  const WorkoutSessionRules._();

  static DateTime normalizeSessionDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static bool hasSessionForPlanDayAndDate({
    required Iterable<WorkoutSession> sessions,
    required String planDayId,
    required DateTime sessionDate,
  }) {
    final normalizedDate = normalizeSessionDate(sessionDate);

    return sessions.any(
      (session) =>
          session.planDayId == planDayId &&
          session.sessionDate == normalizedDate,
    );
  }

  static void validateUniqueSessions(Iterable<WorkoutSession> sessions) {
    final keys = <String>{};

    for (final session in sessions) {
      final key = '${session.planDayId}_${session.sessionDate.toIso8601String()}';
      if (!keys.add(key)) {
        throw StateError(
          'There must be only one session per plan day and calendar date.',
        );
      }
    }
  }
}