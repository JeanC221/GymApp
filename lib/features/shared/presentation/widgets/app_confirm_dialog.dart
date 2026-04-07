import 'package:flutter/material.dart';
import 'package:smartfit/app/theme/tokens/app_spacing.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_primary_button.dart';
import 'package:smartfit/features/shared/presentation/widgets/app_secondary_button.dart';

class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    required this.title,
    required this.description,
    required this.confirmLabel,
    super.key,
    this.cancelLabel = 'Cancel',
    this.onConfirm,
  });

  final String title;
  final String description;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: AppSecondaryButton(
                    label: cancelLabel,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppPrimaryButton(
                    label: confirmLabel,
                    onPressed: () {
                      onConfirm?.call();
                      Navigator.of(context).pop(true);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}