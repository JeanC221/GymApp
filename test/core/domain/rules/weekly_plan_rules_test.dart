import 'package:flutter_test/flutter_test.dart';
import 'package:smartfit/core/domain/entities/plan_day.dart';
import 'package:smartfit/core/domain/enums/plan_day_type.dart';
import 'package:smartfit/core/domain/enums/weekday.dart';
import 'package:smartfit/core/domain/rules/weekly_plan_rules.dart';

void main() {
  group('WeeklyPlanRules', () {
    test('throws when duplicate weekdays are detected', () {
      final days = [
        PlanDay(
          id: 'day-1',
          weeklyPlanId: 'plan-1',
          weekday: Weekday.monday,
          type: PlanDayType.training,
          routineName: 'Push',
          orderIndex: 0,
        ),
        PlanDay(
          id: 'day-2',
          weeklyPlanId: 'plan-1',
          weekday: Weekday.monday,
          type: PlanDayType.training,
          routineName: 'Pull',
          orderIndex: 1,
        ),
      ];

      expect(() => WeeklyPlanRules.validateUniqueWeekdays(days), throwsStateError);
    });

    test('returns only unused weekdays as available', () {
      final days = [
        PlanDay(
          id: 'day-1',
          weeklyPlanId: 'plan-1',
          weekday: Weekday.monday,
          type: PlanDayType.training,
          routineName: 'Push',
          orderIndex: 0,
        ),
        PlanDay(
          id: 'day-2',
          weeklyPlanId: 'plan-1',
          weekday: Weekday.wednesday,
          type: PlanDayType.rest,
          orderIndex: 1,
        ),
      ];

      final available = WeeklyPlanRules.availableWeekdays(days);

      expect(available.contains(Weekday.monday), isFalse);
      expect(available.contains(Weekday.wednesday), isFalse);
      expect(available.contains(Weekday.friday), isTrue);
    });
  });
}