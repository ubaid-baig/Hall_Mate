import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';

/// Both themes live here, so main.dart stays clean.
/// main.dart only says: theme: AppTheme.lightTheme, darkTheme: AppTheme.darkTheme
class AppTheme {
  AppTheme._(); // prevent instantiation

  // ── LIGHT ──────────────────────────────────────────────────
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.light.bgScreen,
    splashColor: Colors.transparent,
    colorScheme: ColorScheme.light(
      primary: AppColors.light.primaryInk,
      onPrimary: AppColors.light.textOnPrimary,
      surface: AppColors.light.bgSurface,
      onSurface: AppColors.light.textPrimary,
      error: AppColors.light.danger,
    ),
    // Default text color for every Text that has no color of its own.
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.light.textPrimary),
      bodyMedium: TextStyle(color: AppColors.light.textPrimary),
      bodySmall: TextStyle(color: AppColors.light.textPrimary),
      titleMedium: TextStyle(color: AppColors.light.textPrimary),
    ),
  );

  // ── DARK ───────────────────────────────────────────────────
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.dark.bgScreen,
    splashColor: Colors.transparent,
    colorScheme: ColorScheme.dark(
      primary: AppColors.dark.primaryInk,
      onPrimary: AppColors.dark.textOnPrimary,
      surface: AppColors.dark.bgSurface,
      onSurface: AppColors.dark.textPrimary,
      error: AppColors.dark.danger,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.dark.textPrimary),
      bodyMedium: TextStyle(color: AppColors.dark.textPrimary),
      bodySmall: TextStyle(color: AppColors.dark.textPrimary),
      titleMedium: TextStyle(color: AppColors.dark.textPrimary),
    ),
  );
}
