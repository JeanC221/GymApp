import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartfit/app/bootstrap/app_bootstrap.dart';
import 'package:smartfit/core/domain/entities/app_settings.dart';
import 'package:smartfit/core/domain/enums/app_theme_preference.dart';
import 'package:smartfit/core/domain/enums/progress_range.dart';
import 'package:smartfit/core/domain/enums/weight_unit.dart';

final currentAppSettingsProvider = FutureProvider<AppSettings>((ref) async {
  final bootstrap = await ref.watch(appBootstrapProvider.future);
  return await bootstrap.settingsRepository.getSettings() ?? defaultAppSettings();
});

final settingsControllerProvider = Provider<SettingsController>((ref) {
  return SettingsController(ref);
});

class SettingsController {
  SettingsController(this._ref);

  final Ref _ref;

  Future<void> saveThemeMode(AppThemePreference themeMode) async {
    await _save((settings) => settings.copyWith(themeMode: themeMode));
  }

  Future<void> saveWeightUnit(WeightUnit weightUnit) async {
    await _save((settings) => settings.copyWith(weightUnit: weightUnit));
  }

  Future<void> markBackupExported(DateTime exportedAt) async {
    await _save((settings) => settings.copyWith(lastBackupAt: exportedAt));
  }

  Future<void> _save(AppSettings Function(AppSettings settings) update) async {
    final bootstrap = await _ref.read(appBootstrapProvider.future);
    final repository = bootstrap.settingsRepository;
    final current = await repository.getSettings() ?? defaultAppSettings();
    await repository.saveSettings(update(current));
    _ref.invalidate(currentAppSettingsProvider);
  }
}

AppSettings defaultAppSettings() {
  return const AppSettings(
    id: 'settings',
    themeMode: AppThemePreference.system,
    weightUnit: WeightUnit.kg,
    firstLaunchCompleted: true,
    lastBackupAt: null,
    preferredGraphRange: ProgressRange.last30Days,
  );
}

ThemeMode appThemeModeFromPreference(AppThemePreference preference) {
  return switch (preference) {
    AppThemePreference.system => ThemeMode.system,
    AppThemePreference.light => ThemeMode.light,
    AppThemePreference.dark => ThemeMode.dark,
  };
}