import 'package:isar/isar.dart';

part 'cardio_template_record.g.dart';

@collection
class CardioTemplateRecord {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String exerciseTemplateId;

  late String cardioType;
  int? defaultDurationMinutes;
  double? defaultIncline;
}