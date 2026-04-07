import 'package:flutter/material.dart';
import 'package:smartfit/app/theme/tokens/app_spacing.dart';

class AppBottomSheetScaffold extends StatelessWidget {
  const AppBottomSheetScaffold({
    required this.title,
    required this.child,
    super.key,
    this.subtitle,
    this.footer,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.md,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(title, style: theme.textTheme.headlineMedium),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(subtitle!, style: theme.textTheme.bodyMedium),
            ],
            const SizedBox(height: AppSpacing.xl),
            child,
            if (footer != null) ...[
              const SizedBox(height: AppSpacing.xl),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}