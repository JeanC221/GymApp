import 'package:isar/isar.dart';

part 'strength_set_log_record.g.dart';

@collection
class StrengthSetLogRecord {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String workoutSessionId;

  @Index()
  late String exerciseTemplateId;

  @Index()
  late int setIndex;

  int? performedReps;
  double? performedWeight;
  late bool isCompleted;

  @Index()
  DateTime? completedAt;
}