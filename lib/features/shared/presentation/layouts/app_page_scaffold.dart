import 'package:flutter/material.dart';
import 'package:smartfit/app/theme/app_theme.dart';
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
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.page),
            child: Column(
              children: [
                if (header != null || actions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                    child: Row(
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
          ),
        ),
      ),
    );
  }
}