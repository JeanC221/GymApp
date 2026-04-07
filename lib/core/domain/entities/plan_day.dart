import 'package:smartfit/core/domain/enums/plan_day_type.dart';
import 'package:smartfit/core/domain/enums/weekday.dart';

class PlanDay {
  PlanDay({
    required this.id,
    required this.weeklyPlanId,
    required this.weekday,
    required this.type,
    required this.orderIndex,
    this.routineName,
  }) : assert(
          type == PlanDayType.rest ||
              (routineName != null && routineName.trim().isNotEmpty),
          'Training days require a routine name.',
        );

  final String id;
  final String weeklyPlanId;
  final Weekday weekday;
  final PlanDayType type;
  final String? routineName;
  final int orderIndex;

  bool get isTrainingDay => type == PlanDayType.training;
  bool get isRestDay => type == PlanDayType.rest;

  PlanDay copyWith({
    String? id,
    String? weeklyPlanId,
    Weekday? weekday,
    PlanDayType? type,
    String? routineName,
    int? orderIndex,
    bool clearRoutineName = false,
  }) {
    return PlanDay(
      id: id ?? this.id,
      weeklyPlanId: weeklyPlanId ?? this.weeklyPlanId,
      weekday: weekday ?? this.weekday,
      type: type ?? this.type,
      routineName: clearRoutineName ? null : (routineName ?? this.routineName),
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}