import 'package:flutter_test/flutter_test.dart';
import 'package:smartfit/core/data/repositories/isar_workout_repository.dart';
import 'package:smartfit/core/domain/entities/strength_set_log.dart';
import 'package:smartfit/core/domain/entities/workout_session.dart';
import 'package:smartfit/core/domain/enums/workout_session_status.dart';

import '_test_isar_helper.dart';

void main() {
  group('IsarWorkoutRepository', () {
    TestIsarHelper? helper;
    IsarWorkoutRepository? repository;

    setUp(() async {
      helper = await TestIsarHelper.create();
      repository = IsarWorkoutRepository(helper!.isar);
    });

    tearDown(() async {
      await helper?.dispose();
    });

    test('rejects duplicate sessions for the same plan day and calendar date', () async {
      await repository!.saveWorkoutSession(
        WorkoutSession(
          id: 'session-1',
          planDayId: 'day-1',
          sessionDate: DateTime(2026, 4, 7, 9),
          sessionStatus: WorkoutSessionStatus.pending,
          createdAt: DateTime(2026, 4, 7, 9),
          updatedAt: DateTime(2026, 4, 7, 9),
        ),
      );

      expect(
        () => repository!.saveWorkoutSession(
          WorkoutSession(
            id: 'session-2',
            planDayId: 'day-1',
            sessionDate: DateTime(2026, 4, 7, 18),
            sessionStatus: WorkoutSessionStatus.completed,
            createdAt: DateTime(2026, 4, 7, 18),
            updatedAt: DateTime(2026, 4, 7, 18),
          ),
        ),
        throwsStateError,
      );
    });

    test('returns the latest completed weighted set for an exercise', () async {
      await repository!.saveWorkoutSession(
        WorkoutSession(
          id: 'session-1',
          planDayId: 'day-1',
          sessionDate: DateTime(2026, 4, 1),
          sessionStatus: WorkoutSessionStatus.completed,
          createdAt: DateTime(2026, 4, 1),
          updatedAt: DateTime(2026, 4, 1),
        ),
      );

      await repository!.saveStrengthSetLogs([
        StrengthSetLog(
          id: 'log-1',
          workoutSessionId: 'session-1',
          exerciseTemplateId: 'exercise-1',
          setIndex: 0,
          performedReps: 8,
          performedWeight: 70,
          isCompleted: true,
          completedAt: DateTime(2026, 4, 1, 10),
        ),
        StrengthSetLog(
          id: 'log-2',
          workoutSessionId: 'session-1',
          exerciseTemplateId: 'exercise-1',
          setIndex: 1,
          performedReps: 6,
          performedWeight: 72.5,
          isCompleted: true,
          completedAt: DateTime(2026, 4, 1, 11),
        ),
      ]);

      final latest = await repository!.getLastUsedWeight('exercise-1');

      expect(latest?.performedWeight, 72.5);
    });
  });
}