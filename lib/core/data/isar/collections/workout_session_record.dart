import 'package:isar/isar.dart';
import 'package:smartfit/core/domain/enums/workout_session_status.dart';

part 'workout_session_record.g.dart';

@collection
class WorkoutSessionRecord {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String planDayId;

  @Index()
  late DateTime sessionDate;

  @enumerated
  late WorkoutSessionStatus sessionStatus;

  late DateTime createdAt;
  late DateTime updatedAt;
}