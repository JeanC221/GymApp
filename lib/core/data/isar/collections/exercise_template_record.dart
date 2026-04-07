import 'package:isar/isar.dart';
import 'package:smartfit/core/domain/enums/exercise_type.dart';

part 'exercise_template_record.g.dart';

@collection
class ExerciseTemplateRecord {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String planDayId;

  @Index()
  late int orderIndex;

  @enumerated
  late ExerciseType type;

  late String displayName;
}