class StrengthSetLog {
  StrengthSetLog({
    required this.id,
    required this.workoutSessionId,
    required this.exerciseTemplateId,
    required this.setIndex,
    this.performedReps,
    this.performedWeight,
    required this.isCompleted,
    this.completedAt,
  }) : assert(setIndex >= 0, 'Set index cannot be negative.'),
       assert(
         performedReps == null || performedReps > 0,
         'Performed reps must be greater than zero.',
       ),
       assert(
         performedWeight == null || performedWeight >= 0,
         'Performed weight cannot be negative.',
       );

  final String id;
  final String workoutSessionId;
  final String exerciseTemplateId;
  final int setIndex;
  final int? performedReps;
  final double? performedWeight;
  final bool isCompleted;
  final DateTime? completedAt;

  StrengthSetLog copyWith({
    String? id,
    String? workoutSessionId,
    String? exerciseTemplateId,
    int? setIndex,
    int? performedReps,
    double? performedWeight,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return StrengthSetLog(
      id: id ?? this.id,
      workoutSessionId: workoutSessionId ?? this.workoutSessionId,
      exerciseTemplateId: exerciseTemplateId ?? this.exerciseTemplateId,
      setIndex: setIndex ?? this.setIndex,
      performedReps: performedReps ?? this.performedReps,
      performedWeight: performedWeight ?? this.performedWeight,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}