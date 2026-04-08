import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartfit/app/bootstrap/app_bootstrap.dart';
import 'package:smartfit/core/domain/entities/plan_day.dart';
import 'package:smartfit/core/domain/entities/weekly_plan.dart';
import 'package:smartfit/core/domain/enums/plan_day_type.dart';
import 'package:smartfit/core/domain/enums/weekday.dart';
import 'package:smartfit/core/domain/repositories/schedule_repository.dart';
import 'package:smartfit/core/domain/rules/plan_day_rules.dart';
import 'package:smartfit/core/domain/rules/weekly_plan_rules.dart';
import 'package:smartfit/core/utils/app_id_factory.dart';

final weekRefreshTickProvider = StateProvider<int>((ref) => 0);
final workoutRefreshTickProvider = StateProvider<int>((ref) => 0);

final weekControllerProvider =
    AsyncNotifierProvider<WeekController, WeekState>(WeekController.new);

class WeekController extends AsyncNotifier<WeekState> {
  @override
  Future<WeekState> build() {
    return _loadState();
  }

  Future<void> createDay({
    required Weekday weekday,
    required PlanDayType type,
    String? routineName,
  }) async {
    state = const AsyncLoading<WeekState>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      final bootstrap = await ref.read(appBootstrapProvider.future);
      final repository = bootstrap.scheduleRepository;
      final plan = await _getOrCreateActivePlan(repository);
      final currentState = await _loadState(repositoryOverride: repository);

      WeeklyPlanRules.validateWeekdayAvailability(
        days: currentState.days.map((item) => item.day),
        targetWeekday: weekday,
      );

      await repository.savePlanDay(
        PlanDay(
          id: AppIdFactory.next('plan_day'),
          weeklyPlanId: plan.id,
          weekday: weekday,
          type: type,
          routineName: type == PlanDayType.training ? routineName?.trim() : null,
          orderIndex: currentState.days.length,
        ),
      );

      _bumpRefreshTick();
      return _loadState(repositoryOverride: repository);
    });
  }

  Future<void> updateDay({
    required String dayId,
    required Weekday weekday,
    required PlanDayType type,
    String? routineName,
    bool forceRestConversion = false,
  }) async {
    final currentState = state.requireValue;
    final currentOverview = currentState.findById(dayId);
    if (currentOverview == null) {
      return;
    }

    final bootstrap = await ref.read(appBootstrapProvider.future);
    final repository = bootstrap.scheduleRepository;
    final exercises = await repository.listExercises(dayId);

    WeeklyPlanRules.validateWeekdayAvailability(
      days: currentState.days.map((item) => item.day),
      targetWeekday: weekday,
      excludingDayId: dayId,
    );

    if (!forceRestConversion) {
      PlanDayRules.validateTypeChange(
        currentDay: currentOverview.day,
        nextType: type,
        hasExercises: exercises.isNotEmpty,
      );
    }

    state = const AsyncLoading<WeekState>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      if (forceRestConversion &&
          currentOverview.day.isTrainingDay &&
          type == PlanDayType.rest &&
          exercises.isNotEmpty) {
        for (final exercise in exercises) {
          await repository.deleteExercise(exercise.id);
        }
      }

      await repository.savePlanDay(
        currentOverview.day.copyWith(
          weekday: weekday,
          type: type,
          routineName: type == PlanDayType.training ? routineName?.trim() : null,
          clearRoutineName: type == PlanDayType.rest,
        ),
      );

      _bumpRefreshTick();
      return _loadState(repositoryOverride: repository);
    });
  }

  Future<void> deleteDay(String dayId) async {
    state = const AsyncLoading<WeekState>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      final bootstrap = await ref.read(appBootstrapProvider.future);
      await bootstrap.scheduleRepository.deletePlanDay(dayId);
      _bumpRefreshTick();
      return _loadState(repositoryOverride: bootstrap.scheduleRepository);
    });
  }

  Future<void> moveDayToWeekday({
    required String dayId,
    required Weekday weekday,
  }) async {
    final currentState = state.requireValue;
    final currentOverview = currentState.findById(dayId);
    if (currentOverview == null) {
      return;
    }

    await updateDay(
      dayId: dayId,
      weekday: weekday,
      type: currentOverview.day.type,
      routineName: currentOverview.day.routineName,
    );
  }

  Future<void> moveDayPosition({
    required String dayId,
    required int offset,
  }) async {
    final currentState = state.requireValue;
    final currentIndex = currentState.days.indexWhere((item) => item.day.id == dayId);
    if (currentIndex == -1) {
      return;
    }

    final nextIndex = currentIndex + offset;
    if (nextIndex < 0 || nextIndex >= currentState.days.length) {
      return;
    }

    state = const AsyncLoading<WeekState>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      final bootstrap = await ref.read(appBootstrapProvider.future);
      final reordered = [...currentState.days.map((item) => item.day)];
      final moved = reordered.removeAt(currentIndex);
      reordered.insert(nextIndex, moved);
      await bootstrap.scheduleRepository.reorderPlanDays(reordered);
      _bumpRefreshTick();
      return _loadState(repositoryOverride: bootstrap.scheduleRepository);
    });
  }

  void _bumpRefreshTick() {
    ref.read(weekRefreshTickProvider.notifier).update((state) => state + 1);
  }

  Future<WeekState> _loadState({ScheduleRepository? repositoryOverride}) async {
    final repository = repositoryOverride ??
        (await ref.watch(appBootstrapProvider.future)).scheduleRepository;
    final activePlan = await repository.getActivePlan();
    if (activePlan == null) {
      return const WeekState(activePlan: null, days: []);
    }

    final days = await repository.listCreatedDays(activePlan.id);
    final overviews = <PlanDayOverview>[];
    for (final day in days) {
      final exerciseCount = (await repository.listExercises(day.id)).length;
      overviews.add(
        PlanDayOverview(
          day: day,
          exerciseCount: exerciseCount,
        ),
      );
    }

    return WeekState(activePlan: activePlan, days: overviews);
  }

  Future<WeeklyPlan> _getOrCreateActivePlan(ScheduleRepository repository) async {
    final existing = await repository.getActivePlan();
    if (existing != null) {
      return existing;
    }

    final now = DateTime.now();
    final created = WeeklyPlan(
      id: AppIdFactory.next('weekly_plan'),
      createdAt: now,
      updatedAt: now,
      isActive: true,
    );
    await repository.saveWeeklyPlan(created);
    return created;
  }
}

class WeekState {
  const WeekState({
    required this.activePlan,
    required this.days,
  });

  final WeeklyPlan? activePlan;
  final List<PlanDayOverview> days;

  bool get hasPlan => activePlan != null;
  bool get isEmpty => days.isEmpty;

  List<Weekday> availableWeekdays({String? excludingDayId}) {
    return WeeklyPlanRules.availableWeekdays(
      days.map((item) => item.day),
      excludingDayId: excludingDayId,
    );
  }

  PlanDayOverview? findById(String dayId) {
    for (final day in days) {
      if (day.day.id == dayId) {
        return day;
      }
    }

    return null;
  }
}

class PlanDayOverview {
  const PlanDayOverview({
    required this.day,
    required this.exerciseCount,
  });

  final PlanDay day;
  final int exerciseCount;

  String get summaryText {
    if (day.isRestDay) {
      return 'Rest day';
    }

    if (exerciseCount == 1) {
      return '1 exercise';
    }

    return '$exerciseCount exercises';
  }
}