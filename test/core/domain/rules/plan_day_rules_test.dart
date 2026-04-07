import 'package:flutter_test/flutter_test.dart';
import 'package:smartfit/core/domain/entities/plan_day.dart';
import 'package:smartfit/core/domain/enums/plan_day_type.dart';
import 'package:smartfit/core/domain/enums/weekday.dart';
import 'package:smartfit/core/domain/rules/plan_day_rules.dart';

void main() {
  group('PlanDayRules', () {
    final trainingDay = PlanDay(
      id: 'day-1',
      weeklyPlanId: 'plan-1',
      weekday: Weekday.monday,
      type: PlanDayType.training,
      routineName: 'Push',
      orderIndex: 0,
    );

    final restDay = PlanDay(
      id: 'day-2',
      weeklyPlanId: 'plan-1',
      weekday: Weekday.wednesday,
      type: PlanDayType.rest,
      orderIndex: 1,
    );

    test('allows exercises on training days', () {
      expect(PlanDayRules.canAcceptExercises(trainingDay), isTrue);
    });

    test('rejects exercises on rest days', () {
      expect(() => PlanDayRules.validateCanAcceptExercises(restDay), throwsStateError);
    });

    test('rejects type change to rest when exercises already exist', () {
      expect(
        () => PlanDayRules.validateTypeChange(
          currentDay: trainingDay,
          nextType: PlanDayType.rest,
          hasExercises: true,
        ),
        throwsStateError,
      );
    });
  });
}