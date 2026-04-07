class StrengthTemplate {
  StrengthTemplate({
    required this.exerciseTemplateId,
    required this.targetSets,
    required this.targetReps,
  }) : assert(targetSets > 0, 'Target sets must be greater than zero.'),
       assert(targetReps > 0, 'Target reps must be greater than zero.');

  final String exerciseTemplateId;
  final int targetSets;
  final int targetReps;

  StrengthTemplate copyWith({
    String? exerciseTemplateId,
    int? targetSets,
    int? targetReps,
  }) {
    return StrengthTemplate(
      exerciseTemplateId: exerciseTemplateId ?? this.exerciseTemplateId,
      targetSets: targetSets ?? this.targetSets,
      targetReps: targetReps ?? this.targetReps,
    );
  }
}