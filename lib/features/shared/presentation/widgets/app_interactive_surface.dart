import 'package:flutter/material.dart';
import 'package:smartfit/app/theme/app_theme.dart';
import 'package:smartfit/app/theme/tokens/app_colors.dart';
import 'package:smartfit/app/theme/tokens/app_radii.dart';
import 'package:smartfit/app/theme/tokens/app_spacing.dart';

enum AppSurfaceState { idle, pressed, dragging, dropTarget, disabled }

class AppInteractiveSurface extends StatefulWidget {
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
  State<AppInteractiveSurface> createState() => _AppInteractiveSurfaceState();
}

class _AppInteractiveSurfaceState extends State<AppInteractiveSurface> {
  bool isPressed = false;
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.extension<AppThemeSurface>()!;
    final effectiveState = _effectiveState;
    final canInteract = widget.state != AppSurfaceState.disabled && widget.onTap != null;

    final effectiveBorder = switch (effectiveState) {
      AppSurfaceState.dropTarget => AppColors.accentStrong,
      AppSurfaceState.dragging => AppColors.info,
      _ => widget.borderColor ??
          (isHovered && canInteract ? AppColors.info.withValues(alpha: 0.45) : surface.outline),
    };

    final effectiveBackground = switch (effectiveState) {
      AppSurfaceState.dropTarget => AppColors.accentTint,
      AppSurfaceState.pressed => surface.secondarySurface,
      _ => widget.backgroundColor ??
          (isHovered && canInteract
              ? surface.secondarySurface.withValues(alpha: 0.55)
              : theme.cardColor),
    };

    final yOffset = switch (effectiveState) {
      AppSurfaceState.pressed => 1.5,
      AppSurfaceState.dragging => -6.0,
      _ => 0.0,
    };

    final scale = switch (effectiveState) {
      AppSurfaceState.pressed => 0.99,
      AppSurfaceState.dragging => 1.02,
      _ => 1.0,
    };

    final opacity = effectiveState == AppSurfaceState.disabled ? 0.6 : 1.0;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: opacity,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        scale: scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, yOffset, 0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: effectiveBackground,
              borderRadius: BorderRadius.circular(widget.radius),
              border: Border.all(color: effectiveBorder),
              boxShadow: surface.cardShadow,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.state == AppSurfaceState.disabled ? null : widget.onTap,
                onHover: canInteract
                    ? (value) => setState(() => isHovered = value)
                    : null,
                onHighlightChanged: canInteract
                    ? (value) => setState(() => isPressed = value)
                    : null,
                mouseCursor: canInteract ? SystemMouseCursors.click : SystemMouseCursors.basic,
                borderRadius: BorderRadius.circular(widget.radius),
                child: Padding(padding: widget.padding, child: widget.child),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppSurfaceState get _effectiveState {
    if (widget.state != AppSurfaceState.idle) {
      return widget.state;
    }
    if (isPressed) {
      return AppSurfaceState.pressed;
    }
    return AppSurfaceState.idle;
  }
}