import 'package:isar/isar.dart';

part 'strength_template_record.g.dart';

@collection
class StrengthTemplateRecord {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String exerciseTemplateId;

  late int targetSets;
  late int targetReps;
}