import 'package:smartfit/core/domain/entities/strength_set_log.dart';

class LastUsedWeightService {
  const LastUsedWeightService._();

  static StrengthSetLog? latestCompletedWeightedSet(
    Iterable<StrengthSetLog> logs,
    String exerciseTemplateId,
  ) {
    final weightedLogs = logs
        .where(
          (log) =>
              log.exerciseTemplateId == exerciseTemplateId &&
              log.isCompleted &&
              log.performedWeight != null,
        )
        .toList(growable: false);

    if (weightedLogs.isEmpty) {
      return null;
    }

    weightedLogs.sort((left, right) {
      final leftCompletedAt = left.completedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rightCompletedAt = right.completedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return rightCompletedAt.compareTo(leftCompletedAt);
    });

    return weightedLogs.first;
  }
}