import 'package:flutter/material.dart';
import 'package:smartfit/app/theme/tokens/app_spacing.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_interactive_surface.dart';

class CardioExerciseCard extends StatelessWidget {
  const CardioExerciseCard({
    required this.name,
    required this.durationSummary,
    required this.detailSummary,
    super.key,
    this.onTap,
    this.state = AppSurfaceState.idle,
  });

  final String name;
  final String durationSummary;
  final String detailSummary;
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
          Text(name, style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(durationSummary, style: theme.textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(detailSummary, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}