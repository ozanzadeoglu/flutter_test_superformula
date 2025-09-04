import 'package:flutter/material.dart';
import 'package:restaurant_tour/core/theme/app_colors.dart';
import 'package:restaurant_tour/core/theme/app_text_styles.dart';

/// Main theme configuration for the app.
class AppTheme {
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      textTheme: _textTheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: _appBarTheme,
      dividerTheme: _dividerTheme,
      splashColor: AppColors.primarySplash,
    );
  }

  /// Light color scheme based on design system
  static const ColorScheme _lightColorScheme = ColorScheme.light(
    primary: AppColors.primaryText,
    secondary: AppColors.secondaryText,
    surface: AppColors.background,
    onSurface: AppColors.primaryText,
    onSurfaceVariant: AppColors.secondaryText,
  );

  /// Text theme mapping design system styles to Flutter TextTheme
  static const TextTheme _textTheme = TextTheme(
    headlineLarge: AppTextStyles.headingLarge,
    headlineMedium: AppTextStyles.headingMedium,
    headlineSmall: AppTextStyles.headingSmall,
    bodyLarge: AppTextStyles.bodyLarge,
    bodyMedium: AppTextStyles.bodyMedium,
    bodySmall: AppTextStyles.bodySmall,
    labelLarge: AppTextStyles.labelLarge,
  );

  /// AppBar theme configuration
  static const AppBarTheme _appBarTheme = AppBarTheme(
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.primaryText,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontFamily: 'Lora',
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: AppColors.primaryText,
    ),
  );

  /// Divider theme configuration
  static const DividerThemeData _dividerTheme = DividerThemeData(
    color: AppColors.dividerLine,
    thickness: 1,
  );
}
