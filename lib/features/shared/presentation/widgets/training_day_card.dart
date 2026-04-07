import 'package:flutter/material.dart';
import 'package:smartfit/app/theme/tokens/app_spacing.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_interactive_surface.dart';

class TrainingDayCard extends StatelessWidget {
  const TrainingDayCard({
    required this.weekdayLabel,
    required this.routineName,
    required this.exerciseSummary,
    super.key,
    this.onTap,
    this.state = AppSurfaceState.idle,
  });

  final String weekdayLabel;
  final String routineName;
  final String exerciseSummary;
  final VoidCallback? onTap;
  final AppSurfaceState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppInteractiveSurface(
      onTap: onTap,
      state: state,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(weekdayLabel.toUpperCase(), style: theme.textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(routineName, style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(exerciseSummary, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}