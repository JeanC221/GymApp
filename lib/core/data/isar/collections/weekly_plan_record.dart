import 'package:isar/isar.dart';

part 'weekly_plan_record.g.dart';

@collection
class WeeklyPlanRecord {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late bool isActive;

  late DateTime createdAt;
  late DateTime updatedAt;
}