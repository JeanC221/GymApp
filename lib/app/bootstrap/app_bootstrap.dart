import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartfit/core/data/isar/smartfit_isar.dart';
import 'package:smartfit/core/data/repositories/isar_schedule_repository.dart';
import 'package:smartfit/core/data/repositories/isar_settings_repository.dart';
import 'package:smartfit/core/data/repositories/isar_workout_repository.dart';
import 'package:smartfit/core/data/seeds/smartfit_dev_seed.dart';
import 'package:smartfit/core/domain/repositories/schedule_repository.dart';
import 'package:smartfit/core/domain/repositories/settings_repository.dart';
import 'package:smartfit/core/domain/repositories/workout_repository.dart';

class AppBootstrap {
  const AppBootstrap({
    required this.scheduleRepository,
    required this.workoutRepository,
    required this.settingsRepository,
  });

  final ScheduleRepository scheduleRepository;
  final WorkoutRepository workoutRepository;
  final SettingsRepository settingsRepository;
}

final appBootstrapProvider = FutureProvider<AppBootstrap>((ref) async {
  final isar = await SmartFitIsar.openDefault();
  ref.onDispose(() {
    unawaited(isar.close());
  });

  final scheduleRepository = IsarScheduleRepository(isar);
  final workoutRepository = IsarWorkoutRepository(isar);
  final settingsRepository = IsarSettingsRepository(isar);

  await SmartFitDevSeed(
    scheduleRepository: scheduleRepository,
    workoutRepository: workoutRepository,
    settingsRepository: settingsRepository,
  ).seedIfEmpty();

  return AppBootstrap(
    scheduleRepository: scheduleRepository,
    workoutRepository: workoutRepository,
    settingsRepository: settingsRepository,
  );
});