import 'package:smartfit/core/domain/enums/workout_session_status.dart';

class WorkoutSession {
  WorkoutSession({
    required this.id,
    required this.planDayId,
    required DateTime sessionDate,
    required this.sessionStatus,
    required this.createdAt,
    required this.updatedAt,
  }) : sessionDate = DateTime(
          sessionDate.year,
          sessionDate.month,
          sessionDate.day,
        );

  final String id;
  final String planDayId;
  final DateTime sessionDate;
  final WorkoutSessionStatus sessionStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  WorkoutSession copyWith({
    String? id,
    String? planDayId,
    DateTime? sessionDate,
    WorkoutSessionStatus? sessionStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WorkoutSession(
      id: id ?? this.id,
      planDayId: planDayId ?? this.planDayId,
      sessionDate: sessionDate ?? this.sessionDate,
      sessionStatus: sessionStatus ?? this.sessionStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}