import 'package:isar/isar.dart';
import 'package:smartfit/core/domain/enums/cardio_source.dart';

part 'cardio_log_record.g.dart';

@collection
class CardioLogRecord {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String workoutSessionId;

  @Index()
  late String exerciseTemplateId;

  @enumerated
  late CardioSource source;

  late String cardioType;
  late int durationMinutes;
  double? incline;
  double? distance;
  int? calories;
  int? averageHeartRate;
}