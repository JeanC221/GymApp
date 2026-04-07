import 'package:flutter_test/flutter_test.dart';
import 'package:smartfit/core/data/repositories/isar_schedule_repository.dart';
import 'package:smartfit/core/domain/entities/exercise_template.dart';
import 'package:smartfit/core/domain/entities/plan_day.dart';
import 'package:smartfit/core/domain/entities/strength_template.dart';
import 'package:smartfit/core/domain/entities/weekly_plan.dart';
import 'package:smartfit/core/domain/enums/exercise_type.dart';
import 'package:smartfit/core/domain/enums/plan_day_type.dart';
import 'package:smartfit/core/domain/enums/weekday.dart';

import '_test_isar_helper.dart';

void main() {
  group('IsarScheduleRepository', () {
    TestIsarHelper? helper;
    IsarScheduleRepository? repository;

    setUp(() async {
      helper = await TestIsarHelper.create();
      repository = IsarScheduleRepository(helper!.isar);
    });

    tearDown(() async {
      await helper?.dispose();
    });

    test('returns the plan day for the requested calendar date', () async {
      final now = DateTime(2026, 4, 7);
      await repository!.saveWeeklyPlan(
        WeeklyPlan(
          id: 'plan-1',
          createdAt: now,
          updatedAt: now,
          isActive: true,
        ),
      );
      await repository!.savePlanDay(
        PlanDay(
          id: 'day-1',
          weeklyPlanId: 'plan-1',
          weekday: Weekday.tuesday,
          type: PlanDayType.training,
          routineName: 'Pull',
          orderIndex: 0,
        ),
      );

      final result = await repository!.getPlanDayForDate(now);

      expect(result?.id, 'day-1');
    });

    test('reorders exercises while preserving the requested plan day', () async {
      final now = DateTime(2026, 4, 7);
      await repository!.saveWeeklyPlan(
        WeeklyPlan(
          id: 'plan-1',
          createdAt: now,
          updatedAt: now,
          isActive: true,
        ),
      );
      await repository!.savePlanDay(
        PlanDay(
          id: 'day-1',
          weeklyPlanId: 'plan-1',
          weekday: Weekday.monday,
          type: PlanDayType.training,
          routineName: 'Push',
          orderIndex: 0,
        ),
      );

      await repository!.saveStrengthExercise(
        exercise: ExerciseTemplate(
          id: 'exercise-1',
          planDayId: 'day-1',
          type: ExerciseType.strength,
          orderIndex: 0,
          displayName: 'Bench Press',
        ),
        template: StrengthTemplate(
          exerciseTemplateId: 'exercise-1',
          targetSets: 3,
          targetReps: 8,
        ),
      );
      await repository!.saveStrengthExercise(
        exercise: ExerciseTemplate(
          id: 'exercise-2',
          planDayId: 'day-1',
          type: ExerciseType.strength,
          orderIndex: 1,
          displayName: 'Incline Press',
        ),
        template: StrengthTemplate(
          exerciseTemplateId: 'exercise-2',
          targetSets: 3,
          targetReps: 10,
        ),
      );

      await repository!.reorderExercises('day-1', [
        ExerciseTemplate(
          id: 'exercise-2',
          planDayId: 'day-1',
          type: ExerciseType.strength,
          orderIndex: 1,
          displayName: 'Incline Press',
        ),
        ExerciseTemplate(
          id: 'exercise-1',
          planDayId: 'day-1',
          type: ExerciseType.strength,
          orderIndex: 0,
          displayName: 'Bench Press',
        ),
      ]);

      final result = await repository!.listExercises('day-1');

      expect(result.first.id, 'exercise-2');
      expect(result.last.id, 'exercise-1');
      expect(result.first.orderIndex, 0);
    });
  });
}