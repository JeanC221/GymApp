import 'package:smartfit/core/domain/entities/plan_day.dart';
import 'package:smartfit/core/domain/enums/plan_day_type.dart';

class PlanDayRules {
  const PlanDayRules._();

  static bool canAcceptExercises(PlanDay day) {
    return day.type == PlanDayType.training;
  }

  static void validateCanAcceptExercises(PlanDay day) {
    if (!canAcceptExercises(day)) {
      throw StateError('Rest days cannot contain exercises.');
    }
  }

  static void validateTypeChange({
    required PlanDay currentDay,
    required PlanDayType nextType,
    required bool hasExercises,
  }) {
    if (
        currentDay.type == PlanDayType.training &&
        nextType == PlanDayType.rest &&
        hasExercises) {
      throw StateError(
        'Cannot change a training day with exercises into a rest day without confirmation.',
      );
    }
  }
}