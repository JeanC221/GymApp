import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartfit/app/theme/tokens/app_breakpoints.dart';
import 'package:smartfit/app/theme/tokens/app_colors.dart';
import 'package:smartfit/app/theme/tokens/app_radii.dart';
import 'package:smartfit/app/theme/tokens/app_shadows.dart';
import 'package:smartfit/app/theme/tokens/app_spacing.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light => _buildTheme(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBackground,
        cardColor: AppColors.lightSurface,
      secondarySurfaceColor: AppColors.lightSurfaceSecondary,
        textColor: AppColors.lightText,
        mutedTextColor: AppColors.lightMutedText,
        outlineColor: AppColors.lightOutline,
        accentColor: AppColors.accent,
      shadowColor: AppColors.lightShadow,
      );

  static ThemeData get dark => _buildTheme(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBackground,
        cardColor: AppColors.darkSurface,
      secondarySurfaceColor: AppColors.darkSurfaceSecondary,
        textColor: AppColors.darkText,
        mutedTextColor: AppColors.darkMutedText,
        outlineColor: AppColors.darkOutline,
        accentColor: AppColors.accent,
      shadowColor: AppColors.darkShadow,
      );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color scaffoldBackgroundColor,
    required Color cardColor,
    required Color secondarySurfaceColor,
    required Color textColor,
    required Color mutedTextColor,
    required Color outlineColor,
    required Color accentColor,
    required Color shadowColor,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      brightness: brightness,
      seedColor: accentColor,
      primary: accentColor,
      surface: cardColor,
      outline: outlineColor,
    );

    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme(
      ThemeData(brightness: brightness).textTheme,
    ).apply(
      bodyColor: textColor,
      displayColor: textColor,
    );
    final displayTextTheme = GoogleFonts.spaceGroteskTextTheme(baseTextTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      shadowColor: shadowColor,
      cardColor: cardColor,
      dividerColor: outlineColor,
      textTheme: displayTextTheme.copyWith(
        displaySmall: displayTextTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -1,
        ),
        headlineLarge: displayTextTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
        ),
        headlineMedium: displayTextTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
        ),
        titleLarge: displayTextTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          height: 1.25,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: mutedTextColor,
          height: 1.35,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          side: BorderSide(color: outlineColor),
        ),
      ),
      canvasColor: secondarySurfaceColor,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: AppColors.actionText,
          minimumSize: const Size.fromHeight(56),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.button),
          ),
          textStyle: baseTextTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          foregroundColor: textColor,
          side: BorderSide(color: outlineColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.button),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          textStyle: baseTextTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cardColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.dialog),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cardColor,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadii.sheet),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: secondarySurfaceColor,
        selectedColor: AppColors.accentTint,
        disabledColor: outlineColor.withValues(alpha: 0.4),
        side: BorderSide(color: outlineColor),
        labelStyle: baseTextTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      extensions: [
        AppThemeSurface(
          secondarySurface: secondarySurfaceColor,
          outline: outlineColor,
          mutedText: mutedTextColor,
          cardShadow: brightness == Brightness.dark
              ? AppShadows.darkCard
              : AppShadows.lightCard,
          maxContentWidth: AppBreakpoints.expanded,
        ),
      ],
    );
  }
}

@immutable
class AppThemeSurface extends ThemeExtension<AppThemeSurface> {
  const AppThemeSurface({
    required this.secondarySurface,
    required this.outline,
    required this.mutedText,
    required this.cardShadow,
    required this.maxContentWidth,
  });

  final Color secondarySurface;
  final Color outline;
  final Color mutedText;
  final List<BoxShadow> cardShadow;
  final double maxContentWidth;

  @override
  AppThemeSurface copyWith({
    Color? secondarySurface,
    Color? outline,
    Color? mutedText,
    List<BoxShadow>? cardShadow,
    double? maxContentWidth,
  }) {
    return AppThemeSurface(
      secondarySurface: secondarySurface ?? this.secondarySurface,
      outline: outline ?? this.outline,
      mutedText: mutedText ?? this.mutedText,
      cardShadow: cardShadow ?? this.cardShadow,
      maxContentWidth: maxContentWidth ?? this.maxContentWidth,
    );
  }

  @override
  AppThemeSurface lerp(ThemeExtension<AppThemeSurface>? other, double t) {
    if (other is! AppThemeSurface) {
      return this;
    }

    return AppThemeSurface(
      secondarySurface: Color.lerp(secondarySurface, other.secondarySurface, t) ?? secondarySurface,
      outline: Color.lerp(outline, other.outline, t) ?? outline,
      mutedText: Color.lerp(mutedText, other.mutedText, t) ?? mutedText,
      cardShadow: t < 0.5 ? cardShadow : other.cardShadow,
      maxContentWidth: lerpDouble(maxContentWidth, other.maxContentWidth, t) ?? maxContentWidth,
    );
  }
}
