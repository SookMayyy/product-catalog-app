import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData light() {

    return ThemeData(
      
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.pinkWhite,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.blushPink,
        primary: AppColors.blushPink,
        secondary: AppColors.nude,
        surface: AppColors.ivory,
        error: AppColors.error,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.blushPink,
        foregroundColor: AppColors.brown,
        elevation: 0,
      ),
      
      cardTheme: CardThemeData(
        color: AppColors.ivory,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brown,
          foregroundColor: AppColors.pinkWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: AppColors.brown),
        titleMedium: TextStyle(color: AppColors.brown, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: AppColors.brown, fontWeight: FontWeight.w700),
      ),

    );
  }
}