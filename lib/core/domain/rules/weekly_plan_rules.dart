import 'package:smartfit/core/domain/entities/plan_day.dart';
import 'package:smartfit/core/domain/enums/weekday.dart';

class WeeklyPlanRules {
  const WeeklyPlanRules._();

  static void validateUniqueWeekdays(Iterable<PlanDay> days) {
    final seen = <Weekday>{};

    for (final day in days) {
      if (!seen.add(day.weekday)) {
        throw StateError('Duplicate weekday detected: ${day.weekday.name}.');
      }
    }
  }

  static List<Weekday> availableWeekdays(
    Iterable<PlanDay> days, {
    String? excludingDayId,
  }) {
    final occupied = days
        .where((day) => excludingDayId == null || day.id != excludingDayId)
        .map((day) => day.weekday)
        .toSet();

    return Weekday.values
        .where((weekday) => !occupied.contains(weekday))
        .toList(growable: false);
  }

  static void validateWeekdayAvailability({
    required Iterable<PlanDay> days,
    required Weekday targetWeekday,
    String? excludingDayId,
  }) {
    final available = availableWeekdays(days, excludingDayId: excludingDayId);
    if (!available.contains(targetWeekday)) {
      throw StateError('Weekday ${targetWeekday.name} is already in use.');
    }
  }
}