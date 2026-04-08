import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartfit/app/bootstrap/app_bootstrap.dart';
import 'package:smartfit/core/data/backup/smartfit_backup_service.dart';
import 'package:smartfit/features/progress/presentation/providers/progress_preferences_provider.dart';
import 'package:smartfit/features/settings/presentation/providers/app_settings_provider.dart';
import 'package:smartfit/features/week/presentation/controllers/week_controller.dart';

final backupControllerProvider =
    AsyncNotifierProvider<BackupController, void>(BackupController.new);

class BackupController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<File> exportBackup() async {
    state = const AsyncLoading<void>().copyWithPrevious(state);
    try {
      final bootstrap = await ref.read(appBootstrapProvider.future);
      final isar = bootstrap.isar;
      if (isar == null) {
        throw const SmartFitBackupException('Backup service is not available.');
      }

      final now = DateTime.now();
      final file = await SmartFitBackupService(isar).exportBackupFile();
      await ref.read(settingsControllerProvider).markBackupExported(now);
      ref.invalidate(currentAppSettingsProvider);
      state = const AsyncData(null);
      return file;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> importBackup(String filePath) async {
    state = const AsyncLoading<void>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      final bootstrap = await ref.read(appBootstrapProvider.future);
      final isar = bootstrap.isar;
      if (isar == null) {
        throw const SmartFitBackupException('Backup service is not available.');
      }

      await SmartFitBackupService(isar).importBackupFile(filePath);
      ref.read(weekRefreshTickProvider.notifier).update((value) => value + 1);
      ref.read(workoutRefreshTickProvider.notifier).update((value) => value + 1);
      ref.invalidate(currentAppSettingsProvider);
      ref.invalidate(preferredProgressRangeProvider);
    });
  }
}