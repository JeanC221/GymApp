import 'package:smartfit/core/domain/entities/cardio_template.dart';
import 'package:smartfit/core/domain/entities/exercise_template.dart';
import 'package:smartfit/core/domain/entities/plan_day.dart';
import 'package:smartfit/core/domain/entities/strength_template.dart';
import 'package:smartfit/core/domain/entities/weekly_plan.dart';
import 'package:smartfit/core/domain/enums/weekday.dart';

abstract interface class ScheduleRepository {
  Future<WeeklyPlan?> getActivePlan();

  Future<void> saveWeeklyPlan(WeeklyPlan plan);

  Future<List<PlanDay>> listPlanDays(String weeklyPlanId);

  Future<List<PlanDay>> listCreatedDays(String weeklyPlanId);

  Future<PlanDay?> getPlanDayForDate(DateTime date);

  Future<PlanDay?> getPlanDayByWeekday(String weeklyPlanId, Weekday weekday);

  Future<void> savePlanDay(PlanDay day);

  Future<void> deletePlanDay(String planDayId);

  Future<List<ExerciseTemplate>> listExercises(String planDayId);

  Future<StrengthTemplate?> getStrengthTemplate(String exerciseTemplateId);

  Future<CardioTemplate?> getCardioTemplate(String exerciseTemplateId);

  Future<void> saveStrengthExercise({
    required ExerciseTemplate exercise,
    required StrengthTemplate template,
  });

  Future<void> saveCardioExercise({
    required ExerciseTemplate exercise,
    required CardioTemplate template,
  });

  Future<void> deleteExercise(String exerciseTemplateId);

  Future<void> reorderPlanDays(List<PlanDay> orderedDays);

  Future<void> reorderExercises(
    String planDayId,
    List<ExerciseTemplate> orderedExercises,
  );
}