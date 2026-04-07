import 'package:flutter/material.dart';
import 'package:smartfit/app/theme/tokens/app_spacing.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_primary_button.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    required this.title,
    required this.description,
    super.key,
    this.buttonLabel,
    this.onPressed,
    this.icon = Icons.inbox_rounded,
  });

  final String title;
  final String description;
  final String? buttonLabel;
  final VoidCallback? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: AppSpacing.lg),
            Text(title, style: theme.textTheme.headlineMedium, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.sm),
            Text(description, style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
            if (buttonLabel != null && onPressed != null) ...[
              const SizedBox(height: AppSpacing.xl),
              AppPrimaryButton(label: buttonLabel!, onPressed: onPressed),
            ],
          ],
        ),
      ),
    );
  }
}