import 'package:flutter/material.dart';
import 'package:smartfit/app/theme/app_theme.dart';
import 'package:smartfit/app/theme/tokens/app_colors.dart';
import 'package:smartfit/app/theme/tokens/app_radii.dart';
import 'package:smartfit/app/theme/tokens/app_spacing.dart';

class AppSegment<T> {
  const AppSegment({required this.value, required this.label, this.icon});

  final T value;
  final String label;
  final IconData? icon;
}

class AppSegmentedControl<T> extends StatelessWidget {
  const AppSegmentedControl({
    required this.value,
    required this.segments,
    required this.onChanged,
    super.key,
  });

  final T value;
  final List<AppSegment<T>> segments;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.extension<AppThemeSurface>()!;
    final selectedIndex = segments.indexWhere((segment) => segment.value == value);

    return LayoutBuilder(
      builder: (context, constraints) {
        final segmentWidth = constraints.maxWidth / segments.length;

        return Container(
          height: 58,
          decoration: BoxDecoration(
            color: surface.secondarySurface,
            borderRadius: BorderRadius.circular(AppRadii.button),
            border: Border.all(color: surface.outline),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                left: segmentWidth * selectedIndex,
                top: 4,
                bottom: 4,
                width: segmentWidth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(AppRadii.button - 4),
                      boxShadow: surface.cardShadow,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  for (final segment in segments)
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppRadii.button),
                        onTap: () => onChanged(segment.value),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (segment.icon != null) ...[
                                  Icon(
                                    segment.icon,
                                    size: 16,
                                    color: segment.value == value
                                        ? theme.textTheme.titleMedium?.color
                                        : AppColors.info,
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                ],
                                Flexible(
                                  child: Text(
                                    segment.label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}