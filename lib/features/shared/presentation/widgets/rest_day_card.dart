import 'package:flutter/material.dart';
import 'package:smartfit/app/theme/tokens/app_spacing.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_interactive_surface.dart';

class RestDayCard extends StatelessWidget {
  const RestDayCard({
    required this.weekdayLabel,
    required this.message,
    super.key,
    this.onTap,
    this.state = AppSurfaceState.idle,
  });

  final String weekdayLabel;
  final String message;
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
          Row(
            children: [
              const Icon(Icons.spa_outlined),
              const SizedBox(width: AppSpacing.sm),
              Text('Rest Day', style: theme.textTheme.headlineMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(message, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}