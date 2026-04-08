import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartfit/app/bootstrap/app_bootstrap.dart';
import 'package:smartfit/core/domain/entities/app_settings.dart';
import 'package:smartfit/core/domain/enums/app_theme_preference.dart';
import 'package:smartfit/core/domain/enums/progress_range.dart';
import 'package:smartfit/core/domain/enums/weight_unit.dart';

final preferredProgressRangeProvider = FutureProvider<ProgressRange>((ref) async {
  final bootstrap = await ref.watch(appBootstrapProvider.future);
  final settings = await bootstrap.settingsRepository.getSettings();
  return settings?.preferredGraphRange ?? ProgressRange.last30Days;
});

final progressPreferencesControllerProvider = Provider<ProgressPreferencesController>((ref) {
  return ProgressPreferencesController(ref);
});

class ProgressPreferencesController {
  ProgressPreferencesController(this._ref);

  final Ref _ref;

  Future<void> savePreferredRange(ProgressRange range) async {
    final bootstrap = await _ref.read(appBootstrapProvider.future);
    final repository = bootstrap.settingsRepository;
    final current = await repository.getSettings();

    final nextSettings = (current ?? _defaultSettings()).copyWith(
      preferredGraphRange: range,
    );
    await repository.saveSettings(nextSettings);
    _ref.invalidate(preferredProgressRangeProvider);
  }

  AppSettings _defaultSettings() {
    return const AppSettings(
      id: 'settings',
      themeMode: AppThemePreference.system,
      weightUnit: WeightUnit.kg,
      firstLaunchCompleted: true,
      lastBackupAt: null,
      preferredGraphRange: ProgressRange.last30Days,
    );
  }
}