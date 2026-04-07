import 'package:flutter_test/flutter_test.dart';
import 'package:smartfit/core/data/export/smartfit_export_service.dart';
import 'package:smartfit/core/data/repositories/isar_settings_repository.dart';
import 'package:smartfit/core/domain/entities/app_settings.dart';
import 'package:smartfit/core/domain/enums/app_theme_preference.dart';
import 'package:smartfit/core/domain/enums/progress_range.dart';
import 'package:smartfit/core/domain/enums/weight_unit.dart';

import '_test_isar_helper.dart';

void main() {
  group('IsarSettingsRepository and SmartFitExportService', () {
    TestIsarHelper? helper;
    IsarSettingsRepository? settingsRepository;
    SmartFitExportService? exportService;

    setUp(() async {
      helper = await TestIsarHelper.create();
      settingsRepository = IsarSettingsRepository(helper!.isar);
      exportService = SmartFitExportService(helper!.isar);
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
  });
}