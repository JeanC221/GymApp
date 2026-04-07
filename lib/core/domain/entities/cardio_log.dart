import 'package:smartfit/core/domain/enums/cardio_source.dart';

class CardioLog {
  CardioLog({
    required this.id,
    required this.workoutSessionId,
    required this.exerciseTemplateId,
    required this.source,
    required this.cardioType,
    required this.durationMinutes,
    this.incline,
    this.distance,
    this.calories,
    this.averageHeartRate,
  }) : assert(cardioType.trim().isNotEmpty, 'Cardio type cannot be empty.'),
       assert(durationMinutes > 0, 'Duration must be greater than zero.'),
       assert(incline == null || incline >= 0, 'Incline cannot be negative.'),
       assert(distance == null || distance >= 0, 'Distance cannot be negative.'),
       assert(calories == null || calories >= 0, 'Calories cannot be negative.'),
       assert(
         averageHeartRate == null || averageHeartRate >= 0,
         'Average heart rate cannot be negative.',
       );

  final String id;
  final String workoutSessionId;
  final String exerciseTemplateId;
  final CardioSource source;
  final String cardioType;
  final int durationMinutes;
  final double? incline;
  final double? distance;
  final int? calories;
  final int? averageHeartRate;

  CardioLog copyWith({
    String? id,
    String? workoutSessionId,
    String? exerciseTemplateId,
    CardioSource? source,
    String? cardioType,
    int? durationMinutes,
    double? incline,
    double? distance,
    int? calories,
    int? averageHeartRate,
  }) {
    return CardioLog(
      id: id ?? this.id,
      workoutSessionId: workoutSessionId ?? this.workoutSessionId,
      exerciseTemplateId: exerciseTemplateId ?? this.exerciseTemplateId,
      source: source ?? this.source,
      cardioType: cardioType ?? this.cardioType,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      incline: incline ?? this.incline,
      distance: distance ?? this.distance,
      calories: calories ?? this.calories,
      averageHeartRate: averageHeartRate ?? this.averageHeartRate,
    );
  }
}