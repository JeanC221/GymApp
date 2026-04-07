import 'package:flutter_test/flutter_test.dart';
import 'package:smartfit/core/domain/entities/strength_set_log.dart';
import 'package:smartfit/core/domain/services/last_used_weight_service.dart';

void main() {
  group('LastUsedWeightService', () {
    test('returns the latest completed weighted set for an exercise', () {
      final logs = [
        StrengthSetLog(
          id: 'log-1',
          workoutSessionId: 'session-1',
          exerciseTemplateId: 'exercise-1',
          setIndex: 0,
          performedReps: 10,
          performedWeight: 50,
          isCompleted: true,
          completedAt: DateTime(2026, 4, 1, 10),
        ),
        StrengthSetLog(
          id: 'log-2',
          workoutSessionId: 'session-2',
          exerciseTemplateId: 'exercise-1',
          setIndex: 0,
          performedReps: 8,
          performedWeight: 55,
          isCompleted: true,
          completedAt: DateTime(2026, 4, 5, 10),
        ),
      ];

      final latest = LastUsedWeightService.latestCompletedWeightedSet(
        logs,
        'exercise-1',
      );

      expect(latest?.performedWeight, 55);
      expect(latest?.performedReps, 8);
    });
  });
}