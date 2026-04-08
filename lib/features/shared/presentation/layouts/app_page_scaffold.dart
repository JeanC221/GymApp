import 'package:flutter/material.dart';
import 'package:smartfit/app/theme/app_theme.dart';
import 'package:smartfit/app/theme/tokens/app_breakpoints.dart';
import 'package:smartfit/app/theme/tokens/app_spacing.dart';

class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    required this.child,
    super.key,
    this.header,
    this.actions = const [],
  });

  final Widget child;
  final Widget? header;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).extension<AppThemeSurface>()!;

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: surface.maxContentWidth),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final shouldStackHeader = constraints.maxWidth < AppBreakpoints.compact;

              return Padding(
                padding: const EdgeInsets.all(AppSpacing.page),
                child: Column(
                  children: [
                    if (header != null || actions.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                        child: shouldStackHeader
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    // ignore: use_null_aware_elements
                                    if (header != null) header!,
                                  if (actions.isNotEmpty) ...[
                                    const SizedBox(height: AppSpacing.lg),
                                    Wrap(
                                      spacing: AppSpacing.md,
                                      runSpacing: AppSpacing.md,
                                      children: actions,
                                    ),
                                  ],
                                ],
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: header ?? const SizedBox.shrink()),
                                  if (actions.isNotEmpty) ...actions,
                                ],
                              ),
                      ),
                    Expanded(child: child),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}