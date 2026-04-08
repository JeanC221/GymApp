import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartfit/app/bootstrap/app_bootstrap.dart';
import 'package:smartfit/core/domain/entities/exercise_template.dart';
import 'package:smartfit/core/domain/entities/plan_day.dart';
import 'package:smartfit/core/domain/enums/exercise_type.dart';
import 'package:smartfit/core/domain/enums/progress_range.dart';
import 'package:smartfit/core/domain/enums/weight_unit.dart';
import 'package:smartfit/core/domain/enums/workout_session_status.dart';
import 'package:smartfit/features/week/presentation/controllers/week_controller.dart';

final progressOverviewProvider =
    FutureProvider.family<ProgressOverview, ProgressRange>((ref, range) async {
  ref.watch(weekRefreshTickProvider);
  ref.watch(workoutRefreshTickProvider);

  final bootstrap = await ref.watch(appBootstrapProvider.future);
  final scheduleRepository = bootstrap.scheduleRepository;
  final workoutRepository = bootstrap.workoutRepository;
  final settings = await bootstrap.settingsRepository.getSettings();
  final weightUnit = settings?.weightUnit ?? WeightUnit.kg;
  final activePlan = await scheduleRepository.getActivePlan();

  if (activePlan == null) {
    return ProgressOverview.empty(
      range: range,
      weightUnit: weightUnit,
    );
  }

  final now = DateTime.now();
  final days = await scheduleRepository.listCreatedDays(activePlan.id);
  final exerciseContexts = <_ExerciseContext>[];

  for (final day in days) {
    final exercises = await scheduleRepository.listExercises(day.id);
    for (final exercise in exercises) {
      exerciseContexts.add(_ExerciseContext(exercise: exercise, day: day));
    }
  }

  final strengthSeriesByExercise = <String, Map<DateTime, double>>{};
  final cardioSeriesByExercise = <String, Map<DateTime, int>>{};
  final completedSetsByExercise = <String, int>{};
  final cardioMinutesByExercise = <String, int>{};
  final lastUsedWeightByExercise = <String, double?>{};
  final overallCompletedSessions = <DateTime, int>{};
  final overallCardioMinutes = <DateTime, int>{};

  for (final context in exerciseContexts) {
    strengthSeriesByExercise.putIfAbsent(context.exercise.id, () => <DateTime, double>{});
    cardioSeriesByExercise.putIfAbsent(context.exercise.id, () => <DateTime, int>{});
    final lastUsed = await workoutRepository.getLastUsedWeight(context.exercise.id);
    lastUsedWeightByExercise[context.exercise.id] = lastUsed?.performedWeight;
  }

  var completedSessionCount = 0;
  var completedStrengthSetCount = 0;
  var totalCardioMinutes = 0;

  for (final day in days) {
    final sessions = await workoutRepository.listSessionsForPlanDay(day.id);
    for (final session in sessions) {
      if (!_isInRange(session.sessionDate, range, now)) {
        continue;
      }

      if (session.sessionStatus == WorkoutSessionStatus.completed) {
        completedSessionCount += 1;
        final weekStart = _startOfWeek(session.sessionDate);
        overallCompletedSessions.update(weekStart, (value) => value + 1, ifAbsent: () => 1);
      }

      final strengthLogs = await workoutRepository.listStrengthSetLogs(session.id);
      for (final log in strengthLogs) {
        if (!log.isCompleted) {
          continue;
        }
        completedStrengthSetCount += 1;
        completedSetsByExercise.update(log.exerciseTemplateId, (value) => value + 1, ifAbsent: () => 1);

        if (log.performedWeight == null) {
          continue;
        }

        final entries = strengthSeriesByExercise.putIfAbsent(
          log.exerciseTemplateId,
          () => <DateTime, double>{},
        );
        final current = entries[session.sessionDate];
        if (current == null || log.performedWeight! > current) {
          entries[session.sessionDate] = log.performedWeight!;
        }
      }

      final cardioLogs = await workoutRepository.listCardioLogs(session.id);
      var sessionCardioMinutes = 0;
      for (final log in cardioLogs) {
        totalCardioMinutes += log.durationMinutes;
        sessionCardioMinutes += log.durationMinutes;
        cardioMinutesByExercise.update(
          log.exerciseTemplateId,
          (value) => value + log.durationMinutes,
          ifAbsent: () => log.durationMinutes,
        );

        final entries = cardioSeriesByExercise.putIfAbsent(
          log.exerciseTemplateId,
          () => <DateTime, int>{},
        );
        entries.update(
          session.sessionDate,
          (value) => value + log.durationMinutes,
          ifAbsent: () => log.durationMinutes,
        );
      }

      if (sessionCardioMinutes > 0) {
        final weekStart = _startOfWeek(session.sessionDate);
        overallCardioMinutes.update(
          weekStart,
          (value) => value + sessionCardioMinutes,
          ifAbsent: () => sessionCardioMinutes,
        );
      }
    }
  }

  final exerciseHistories = [
    for (final context in exerciseContexts)
      ProgressExerciseHistory(
        exerciseId: context.exercise.id,
        displayName: context.exercise.displayName,
        dayLabel: _planDayLabel(context.day),
        type: context.exercise.type,
        lastUsedWeight: lastUsedWeightByExercise[context.exercise.id],
        series: context.exercise.type == ExerciseType.strength
            ? _toSeriesPointsDouble(strengthSeriesByExercise[context.exercise.id] ?? const <DateTime, double>{})
            : _toSeriesPointsInt(cardioSeriesByExercise[context.exercise.id] ?? const <DateTime, int>{}),
        completedStrengthSets: completedSetsByExercise[context.exercise.id] ?? 0,
        totalCardioMinutes: cardioMinutesByExercise[context.exercise.id] ?? 0,
      ),
  ]
    ..sort((left, right) {
      final labelCompare = left.displayName.toLowerCase().compareTo(right.displayName.toLowerCase());
      if (labelCompare != 0) {
        return labelCompare;
      }
      return left.dayLabel.compareTo(right.dayLabel);
    });

  return ProgressOverview(
    range: range,
    weightUnit: weightUnit,
    exerciseHistories: exerciseHistories,
    overallCompletedSessionSeries: _toSeriesPointsInt(overallCompletedSessions),
    overallCardioMinuteSeries: _toSeriesPointsInt(overallCardioMinutes),
    completedSessionCount: completedSessionCount,
    completedStrengthSetCount: completedStrengthSetCount,
    totalCardioMinutes: totalCardioMinutes,
  );
});

class ProgressOverview {
  const ProgressOverview({
    required this.range,
    required this.weightUnit,
    required this.exerciseHistories,
    required this.overallCompletedSessionSeries,
    required this.overallCardioMinuteSeries,
    required this.completedSessionCount,
    required this.completedStrengthSetCount,
    required this.totalCardioMinutes,
  });

  factory ProgressOverview.empty({
    required ProgressRange range,
    required WeightUnit weightUnit,
  }) {
    return ProgressOverview(
      range: range,
      weightUnit: weightUnit,
      exerciseHistories: const [],
      overallCompletedSessionSeries: const [],
      overallCardioMinuteSeries: const [],
      completedSessionCount: 0,
      completedStrengthSetCount: 0,
      totalCardioMinutes: 0,
    );
  }

  final ProgressRange range;
  final WeightUnit weightUnit;
  final List<ProgressExerciseHistory> exerciseHistories;
  final List<ProgressSeriesPoint> overallCompletedSessionSeries;
  final List<ProgressSeriesPoint> overallCardioMinuteSeries;
  final int completedSessionCount;
  final int completedStrengthSetCount;
  final int totalCardioMinutes;

  bool get hasAnyHistory {
    return completedSessionCount > 0 ||
        completedStrengthSetCount > 0 ||
        totalCardioMinutes > 0;
  }

  ProgressExerciseHistory? historyFor(String exerciseId) {
    for (final history in exerciseHistories) {
      if (history.exerciseId == exerciseId) {
        return history;
      }
    }
    return null;
  }

  ProgressExerciseHistory? get defaultExerciseHistory {
    for (final history in exerciseHistories) {
      if (history.hasHistory) {
        return history;
      }
    }
    if (exerciseHistories.isEmpty) {
      return null;
    }
    return exerciseHistories.first;
  }
}

class ProgressExerciseHistory {
  const ProgressExerciseHistory({
    required this.exerciseId,
    required this.displayName,
    required this.dayLabel,
    required this.type,
    required this.lastUsedWeight,
    required this.series,
    required this.completedStrengthSets,
    required this.totalCardioMinutes,
  });

  final String exerciseId;
  final String displayName;
  final String dayLabel;
  final ExerciseType type;
  final double? lastUsedWeight;
  final List<ProgressSeriesPoint> series;
  final int completedStrengthSets;
  final int totalCardioMinutes;

  bool get hasHistory => series.isNotEmpty;

  String get optionLabel => '$displayName · $dayLabel';
}

class ProgressSeriesPoint {
  const ProgressSeriesPoint({
    required this.date,
    required this.label,
    required this.value,
  });

  final DateTime date;
  final String label;
  final double value;
}

class _ExerciseContext {
  const _ExerciseContext({
    required this.exercise,
    required this.day,
  });

  final ExerciseTemplate exercise;
  final PlanDay day;
}

bool _isInRange(DateTime date, ProgressRange range, DateTime now) {
  final normalizedNow = DateTime(now.year, now.month, now.day);
  final normalizedDate = DateTime(date.year, date.month, date.day);

  return switch (range) {
    ProgressRange.last30Days => !normalizedDate.isBefore(
        normalizedNow.subtract(const Duration(days: 29)),
      ),
    ProgressRange.last8Weeks => !normalizedDate.isBefore(
        normalizedNow.subtract(const Duration(days: 55)),
      ),
    ProgressRange.allTime => true,
  };
}

DateTime _startOfWeek(DateTime date) {
  final normalizedDate = DateTime(date.year, date.month, date.day);
  return normalizedDate.subtract(Duration(days: normalizedDate.weekday - 1));
}

String _planDayLabel(PlanDay day) {
  return day.routineName == null
      ? day.weekday.displayName
      : '${day.weekday.displayName} · ${day.routineName}';
}

List<ProgressSeriesPoint> _toSeriesPointsDouble(Map<DateTime, double> valuesByDate) {
  final entries = valuesByDate.entries.toList()
    ..sort((left, right) => left.key.compareTo(right.key));
  return [
    for (final entry in entries)
      ProgressSeriesPoint(
        date: entry.key,
        label: _dateLabel(entry.key),
        value: entry.value,
      ),
  ];
}

List<ProgressSeriesPoint> _toSeriesPointsInt(Map<DateTime, int> valuesByDate) {
  final entries = valuesByDate.entries.toList()
    ..sort((left, right) => left.key.compareTo(right.key));
  return [
    for (final entry in entries)
      ProgressSeriesPoint(
        date: entry.key,
        label: _dateLabel(entry.key),
        value: entry.value.toDouble(),
      ),
  ];
}

String _dateLabel(DateTime date) => '${date.month}/${date.day}';