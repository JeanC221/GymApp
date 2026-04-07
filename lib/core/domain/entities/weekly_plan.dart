class WeeklyPlan {
  const WeeklyPlan({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  WeeklyPlan copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return WeeklyPlan(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}