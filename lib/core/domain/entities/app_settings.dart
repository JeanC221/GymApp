import 'package:smartfit/core/domain/enums/app_theme_preference.dart';
import 'package:smartfit/core/domain/enums/progress_range.dart';
import 'package:smartfit/core/domain/enums/weight_unit.dart';

class AppSettings {
  const AppSettings({
    required this.id,
    required this.themeMode,
    required this.weightUnit,
    required this.firstLaunchCompleted,
    this.lastBackupAt,
    required this.preferredGraphRange,
  });

  final String id;
  final AppThemePreference themeMode;
  final WeightUnit weightUnit;
  final bool firstLaunchCompleted;
  final DateTime? lastBackupAt;
  final ProgressRange preferredGraphRange;

  AppSettings copyWith({
    String? id,
    AppThemePreference? themeMode,
    WeightUnit? weightUnit,
    bool? firstLaunchCompleted,
    DateTime? lastBackupAt,
    ProgressRange? preferredGraphRange,
  }) {
    return AppSettings(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
      weightUnit: weightUnit ?? this.weightUnit,
      firstLaunchCompleted: firstLaunchCompleted ?? this.firstLaunchCompleted,
      lastBackupAt: lastBackupAt ?? this.lastBackupAt,
      preferredGraphRange: preferredGraphRange ?? this.preferredGraphRange,
    );
  }
}