import 'package:isar/isar.dart';
import 'package:smartfit/core/domain/enums/plan_day_type.dart';
import 'package:smartfit/core/domain/enums/weekday.dart';

part 'plan_day_record.g.dart';

@collection
class PlanDayRecord {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String weeklyPlanId;

  @Index()
  @enumerated
  late Weekday weekday;

  @enumerated
  late PlanDayType type;

  String? routineName;
  late int orderIndex;
}