import 'package:isar/isar.dart';
import 'package:smartfit/core/domain/enums/app_theme_preference.dart';
import 'package:smartfit/core/domain/enums/progress_range.dart';
import 'package:smartfit/core/domain/enums/weight_unit.dart';

part 'app_settings_record.g.dart';

@collection
class AppSettingsRecord {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @enumerated
  late AppThemePreference themeMode;

  @enumerated
  late WeightUnit weightUnit;

  late bool firstLaunchCompleted;
  DateTime? lastBackupAt;

  @enumerated
  late ProgressRange preferredGraphRange;
}