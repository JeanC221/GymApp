import 'package:flutter/material.dart';
import 'package:smartfit/app/theme/tokens/app_colors.dart';

class AppShadows {
  const AppShadows._();

  static List<BoxShadow> lightCard = const [
    BoxShadow(
      color: AppColors.lightShadow,
      blurRadius: 28,
      offset: Offset(0, 12),
      spreadRadius: -12,
    ),
  ];

  static List<BoxShadow> darkCard = const [
    BoxShadow(
      color: AppColors.darkShadow,
      blurRadius: 30,
      offset: Offset(0, 16),
      spreadRadius: -14,
    ),
  ];

  static List<BoxShadow> accentGlow = const [
    BoxShadow(
      color: AppColors.accentGlow,
      blurRadius: 28,
      offset: Offset(0, 10),
      spreadRadius: -8,
    ),
  ];
}