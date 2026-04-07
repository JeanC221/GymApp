class CardioTemplate {
  CardioTemplate({
    required this.exerciseTemplateId,
    required this.cardioType,
    this.defaultDurationMinutes,
    this.defaultIncline,
  }) : assert(cardioType.trim().isNotEmpty, 'Cardio type cannot be empty.'),
       assert(
         defaultDurationMinutes == null || defaultDurationMinutes > 0,
         'Default duration must be greater than zero.',
       ),
       assert(
         defaultIncline == null || defaultIncline >= 0,
         'Default incline cannot be negative.',
       );

  final String exerciseTemplateId;
  final String cardioType;
  final int? defaultDurationMinutes;
  final double? defaultIncline;

  CardioTemplate copyWith({
    String? exerciseTemplateId,
    String? cardioType,
    int? defaultDurationMinutes,
    double? defaultIncline,
  }) {
    return CardioTemplate(
      exerciseTemplateId: exerciseTemplateId ?? this.exerciseTemplateId,
      cardioType: cardioType ?? this.cardioType,
      defaultDurationMinutes: defaultDurationMinutes ?? this.defaultDurationMinutes,
      defaultIncline: defaultIncline ?? this.defaultIncline,
    );
  }
}