import 'package:flutter/material.dart';
import 'package:smartfit/app/theme/app_theme.dart';
import 'package:smartfit/app/theme/tokens/app_colors.dart';
import 'package:smartfit/app/theme/tokens/app_radii.dart';
import 'package:smartfit/app/theme/tokens/app_spacing.dart';

enum AppSurfaceState { idle, pressed, dragging, dropTarget, disabled }

class AppInteractiveSurface extends StatelessWidget {
  const AppInteractiveSurface({
    required this.child,
    super.key,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.radius = AppRadii.card,
    this.state = AppSurfaceState.idle,
    this.borderColor,
    this.backgroundColor,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double radius;
  final AppSurfaceState state;
  final Color? borderColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.extension<AppThemeSurface>()!;

    final effectiveBorder = switch (state) {
      AppSurfaceState.dropTarget => AppColors.accentStrong,
      AppSurfaceState.dragging => AppColors.info,
      _ => borderColor ?? surface.outline,
    };

    final effectiveBackground = switch (state) {
      AppSurfaceState.dropTarget => AppColors.accentTint,
      AppSurfaceState.pressed => surface.secondarySurface,
      _ => backgroundColor ?? theme.cardColor,
    };

    final yOffset = switch (state) {
      AppSurfaceState.pressed => 1.5,
      AppSurfaceState.dragging => -6.0,
      _ => 0.0,
    };

    final scale = switch (state) {
      AppSurfaceState.pressed => 0.99,
      AppSurfaceState.dragging => 1.02,
      _ => 1.0,
    };

    final opacity = state == AppSurfaceState.disabled ? 0.6 : 1.0;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: opacity,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 180),
        tween: Tween(begin: scale, end: scale),
        builder: (context, _, childWidget) {
          return Transform.translate(
            offset: Offset(0, yOffset),
            child: Transform.scale(scale: scale, child: childWidget),
          );
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: effectiveBackground,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: effectiveBorder),
            boxShadow: surface.cardShadow,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: state == AppSurfaceState.disabled ? null : onTap,
              borderRadius: BorderRadius.circular(radius),
              child: Padding(padding: padding, child: child),
            ),
          ),
        ),
      ),
    );
  }
}