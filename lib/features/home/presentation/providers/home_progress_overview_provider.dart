import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartfit/core/domain/enums/progress_range.dart';
import 'package:smartfit/features/progress/presentation/providers/progress_overview_provider.dart';
import 'package:smartfit/features/progress/presentation/providers/progress_preferences_provider.dart';

final homeProgressOverviewProvider = FutureProvider<ProgressOverview>((ref) async {
  final preferredRange = await ref.watch(preferredProgressRangeProvider.future);
  return ref.watch(progressOverviewProvider(preferredRange).future);
});

String homeProgressRangeLabel(ProgressRange range) {
  return switch (range) {
    ProgressRange.last30Days => 'Last 30 days',
    ProgressRange.last8Weeks => 'Last 8 weeks',
    ProgressRange.allTime => 'All time',
  };
}