import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTypography.fontFamily,
      scaffoldBackgroundColor: AppColors.surface50,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary700,
        secondary: AppColors.primary500,
        error: AppColors.error,
        surface: AppColors.surface0,
      ),
      textTheme: const TextTheme(
        displayLarge: AppTypography.display,
        headlineLarge: AppTypography.h1,
        headlineMedium: AppTypography.h2,
        bodyLarge: AppTypography.body,
        bodyMedium: AppTypography.body,
        labelLarge: AppTypography.buttonLabel,
        bodySmall: AppTypography.caption,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface50,
        elevation: 0,
        centerTitle: false,
        foregroundColor: AppColors.ink900,
        titleTextStyle: AppTypography.h1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary700,
          foregroundColor: AppColors.surface0,
          textStyle: AppTypography.buttonLabel,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary700,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.chipRadius),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface100,
        border: OutlineInputBorder(
          borderRadius: AppRadius.chipRadius,
          borderSide: const BorderSide(color: AppColors.border),
        ),
      ),
      dividerColor: AppColors.border,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface0,
        selectedItemColor: AppColors.primary700,
        unselectedItemColor: AppColors.ink300,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
