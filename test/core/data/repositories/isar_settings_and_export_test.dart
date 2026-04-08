import 'package:flutter_test/flutter_test.dart';
import 'package:smartfit/core/data/backup/smartfit_backup_service.dart';
import 'package:smartfit/core/data/export/smartfit_export_service.dart';
import 'package:smartfit/core/data/isar/collections/app_settings_record.dart';
import 'package:smartfit/core/data/isar/collections/cardio_log_record.dart';
import 'package:smartfit/core/data/isar/collections/cardio_template_record.dart';
import 'package:smartfit/core/data/isar/collections/exercise_template_record.dart';
import 'package:smartfit/core/data/isar/collections/plan_day_record.dart';
import 'package:smartfit/core/data/isar/collections/strength_set_log_record.dart';
import 'package:smartfit/core/data/isar/collections/strength_template_record.dart';
import 'package:smartfit/core/data/isar/collections/weekly_plan_record.dart';
import 'package:smartfit/core/data/isar/collections/workout_session_record.dart';
import 'package:smartfit/core/data/repositories/isar_schedule_repository.dart';
import 'package:smartfit/core/data/repositories/isar_settings_repository.dart';
import 'package:smartfit/core/data/repositories/isar_workout_repository.dart';
import 'package:smartfit/core/domain/entities/app_settings.dart';
import 'package:smartfit/core/domain/entities/exercise_template.dart';
import 'package:smartfit/core/domain/entities/plan_day.dart';
import 'package:smartfit/core/domain/entities/strength_set_log.dart';
import 'package:smartfit/core/domain/entities/strength_template.dart';
import 'package:smartfit/core/domain/entities/weekly_plan.dart';
import 'package:smartfit/core/domain/entities/workout_session.dart';
import 'package:smartfit/core/domain/enums/app_theme_preference.dart';
import 'package:smartfit/core/domain/enums/exercise_type.dart';
import 'package:smartfit/core/domain/enums/plan_day_type.dart';
import 'package:smartfit/core/domain/enums/progress_range.dart';
import 'package:smartfit/core/domain/enums/weekday.dart';
import 'package:smartfit/core/domain/enums/weight_unit.dart';
import 'package:smartfit/core/domain/enums/workout_session_status.dart';

import '_test_isar_helper.dart';

void main() {
  group('IsarSettingsRepository and SmartFitExportService', () {
    TestIsarHelper? helper;
    IsarSettingsRepository? settingsRepository;
    IsarScheduleRepository? scheduleRepository;
    IsarWorkoutRepository? workoutRepository;
    SmartFitExportService? exportService;
    SmartFitBackupService? backupService;

    setUp(() async {
      helper = await TestIsarHelper.create();
      settingsRepository = IsarSettingsRepository(helper!.isar);
      scheduleRepository = IsarScheduleRepository(helper!.isar);
      workoutRepository = IsarWorkoutRepository(helper!.isar);
      exportService = SmartFitExportService(helper!.isar);
      backupService = SmartFitBackupService(helper!.isar);
    });

    tearDown(() async {
      await helper?.dispose();
    });

    test('persists app settings and exports a serializable snapshot', () async {
      await settingsRepository!.saveSettings(
        AppSettings(
          id: 'settings',
          themeMode: AppThemePreference.dark,
          weightUnit: WeightUnit.kg,
          firstLaunchCompleted: true,
          lastBackupAt: DateTime(2026, 4, 7),
          preferredGraphRange: ProgressRange.last30Days,
        ),
      );

      final restored = await settingsRepository!.getSettings();
      final snapshot = await exportService!.exportSnapshot();

      expect(restored?.themeMode, AppThemePreference.dark);
      expect(snapshot['schemaVersion'], 1);
      expect(snapshot['settings'], isA<Map<String, dynamic>>());
    });

    test('imports a backup snapshot and replaces local data', () async {
      final sessionDate = DateTime(2026, 4, 7);

      await scheduleRepository!.saveWeeklyPlan(
        WeeklyPlan(
          id: 'plan_1',
          createdAt: DateTime(2026, 4, 1),
          updatedAt: DateTime(2026, 4, 1),
          isActive: true,
        ),
      );
      await scheduleRepository!.savePlanDay(
        PlanDay(
          id: 'day_1',
          weeklyPlanId: 'plan_1',
          weekday: Weekday.monday,
          type: PlanDayType.training,
          routineName: 'Push',
          orderIndex: 0,
        ),
      );
      await scheduleRepository!.saveStrengthExercise(
        exercise: ExerciseTemplate(
          id: 'exercise_1',
          planDayId: 'day_1',
          type: ExerciseType.strength,
          orderIndex: 0,
          displayName: 'Bench Press',
        ),
        template: StrengthTemplate(
          exerciseTemplateId: 'exercise_1',
          targetSets: 4,
          targetReps: 8,
        ),
      );
      await workoutRepository!.saveWorkoutSession(
        WorkoutSession(
          id: 'session_1',
          planDayId: 'day_1',
          sessionDate: sessionDate,
          sessionStatus: WorkoutSessionStatus.completed,
          createdAt: sessionDate,
          updatedAt: sessionDate,
        ),
      );
      await workoutRepository!.saveStrengthSetLog(
        StrengthSetLog(
          id: 'log_1',
          workoutSessionId: 'session_1',
          exerciseTemplateId: 'exercise_1',
          setIndex: 0,
          performedReps: 8,
          performedWeight: 80,
          isCompleted: true,
          completedAt: sessionDate,
        ),
      );
      await settingsRepository!.saveSettings(
        AppSettings(
          id: 'settings',
          themeMode: AppThemePreference.dark,
          weightUnit: WeightUnit.lb,
          firstLaunchCompleted: true,
          lastBackupAt: DateTime(2026, 4, 7),
          preferredGraphRange: ProgressRange.allTime,
        ),
      );

      final snapshot = await exportService!.exportSnapshot();

      await helper!.isar.writeTxn(() async {
        await helper!.isar.cardioLogRecords.clear();
        await helper!.isar.strengthSetLogRecords.clear();
        await helper!.isar.workoutSessionRecords.clear();
        await helper!.isar.cardioTemplateRecords.clear();
        await helper!.isar.strengthTemplateRecords.clear();
        await helper!.isar.exerciseTemplateRecords.clear();
        await helper!.isar.planDayRecords.clear();
        await helper!.isar.weeklyPlanRecords.clear();
        await helper!.isar.appSettingsRecords.clear();
      });

      await backupService!.importSnapshot(snapshot);

      final restoredSettings = await settingsRepository!.getSettings();
      final restoredPlan = await scheduleRepository!.getActivePlan();
      final restoredDays = await scheduleRepository!.listCreatedDays('plan_1');
      final restoredExercises = await scheduleRepository!.listExercises('day_1');
      final restoredSessions = await workoutRepository!.listSessionsForPlanDay('day_1');
      final restoredLogs = await workoutRepository!.listStrengthSetLogs('session_1');

      expect(restoredPlan?.id, 'plan_1');
      expect(restoredDays, hasLength(1));
      expect(restoredExercises.single.displayName, 'Bench Press');
      expect(restoredSessions, hasLength(1));
      expect(restoredLogs.single.performedWeight, 80);
      expect(restoredSettings?.themeMode, AppThemePreference.dark);
      expect(restoredSettings?.weightUnit, WeightUnit.lb);
      expect(restoredSettings?.preferredGraphRange, ProgressRange.allTime);
    });

    test('rejects backup snapshots with unsupported schema versions', () async {
      expect(
        () => backupService!.importSnapshot({
          'schemaVersion': 99,
        }),
        throwsA(isA<SmartFitBackupException>()),
      );
    });
  });
}