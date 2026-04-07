import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smartfit/core/data/isar/collections/app_settings_record.dart';
import 'package:smartfit/core/data/isar/collections/cardio_log_record.dart';
import 'package:smartfit/core/data/isar/collections/cardio_template_record.dart';
import 'package:smartfit/core/data/isar/collections/exercise_template_record.dart';
import 'package:smartfit/core/data/isar/collections/plan_day_record.dart';
import 'package:smartfit/core/data/isar/collections/strength_set_log_record.dart';
import 'package:smartfit/core/data/isar/collections/strength_template_record.dart';
import 'package:smartfit/core/data/isar/collections/weekly_plan_record.dart';
import 'package:smartfit/core/data/isar/collections/workout_session_record.dart';

class SmartFitIsar {
  const SmartFitIsar._();

  static const defaultName = 'smartfit';

  static const schemas = [
    WeeklyPlanRecordSchema,
    PlanDayRecordSchema,
    ExerciseTemplateRecordSchema,
    StrengthTemplateRecordSchema,
    CardioTemplateRecordSchema,
    WorkoutSessionRecordSchema,
    StrengthSetLogRecordSchema,
    CardioLogRecordSchema,
    AppSettingsRecordSchema,
  ];

  static Future<Isar> openDefault({
    String name = defaultName,
    bool inspector = false,
  }) async {
    final directory = await getApplicationSupportDirectory();
    return openAt(
      directory.path,
      name: name,
      inspector: inspector,
    );
  }

  static Future<Isar> openAt(
    String directoryPath, {
    String name = defaultName,
    bool inspector = false,
  }) {
    return Isar.open(
      schemas,
      directory: directoryPath,
      name: name,
      inspector: inspector,
    );
  }
}