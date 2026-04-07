import 'package:smartfit/core/domain/enums/exercise_type.dart';

class ExerciseTemplate {
  ExerciseTemplate({
    required this.id,
    required this.planDayId,
    required this.type,
    required this.orderIndex,
    required this.displayName,
  }) : assert(displayName.trim().isNotEmpty, 'Exercise name cannot be empty.');

  final String id;
  final String planDayId;
  final ExerciseType type;
  final int orderIndex;
  final String displayName;

  ExerciseTemplate copyWith({
    String? id,
    String? planDayId,
    ExerciseType? type,
    int? orderIndex,
    String? displayName,
  }) {
    return ExerciseTemplate(
      id: id ?? this.id,
      planDayId: planDayId ?? this.planDayId,
      type: type ?? this.type,
      orderIndex: orderIndex ?? this.orderIndex,
      displayName: displayName ?? this.displayName,
    );
  }
}