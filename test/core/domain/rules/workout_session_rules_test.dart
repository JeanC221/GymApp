import 'package:flutter_test/flutter_test.dart';
import 'package:smartfit/core/domain/entities/workout_session.dart';
import 'package:smartfit/core/domain/enums/workout_session_status.dart';
import 'package:smartfit/core/domain/rules/workout_session_rules.dart';

void main() {
  group('WorkoutSessionRules', () {
    test('normalizes session dates to calendar day precision', () {
      final date = DateTime(2026, 4, 7, 15, 30);

      expect(
        WorkoutSessionRules.normalizeSessionDate(date),
        DateTime(2026, 4, 7),
      );
    });

    test('rejects duplicate sessions for same day and date', () {
      final sessions = [
        WorkoutSession(
          id: 'session-1',
          planDayId: 'day-1',
          sessionDate: DateTime(2026, 4, 7, 9),
          sessionStatus: WorkoutSessionStatus.pending,
          createdAt: DateTime(2026, 4, 7, 8),
          updatedAt: DateTime(2026, 4, 7, 8),
        ),
        WorkoutSession(
          id: 'session-2',
          planDayId: 'day-1',
          sessionDate: DateTime(2026, 4, 7, 18),
          sessionStatus: WorkoutSessionStatus.completed,
          createdAt: DateTime(2026, 4, 7, 18),
          updatedAt: DateTime(2026, 4, 7, 18),
        ),
      ];

      expect(() => WorkoutSessionRules.validateUniqueSessions(sessions), throwsStateError);
    });
  });
}