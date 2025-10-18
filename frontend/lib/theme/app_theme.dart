import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors_light.dart';
import 'app_colors_dark.dart';

class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Color Scheme
    colorScheme: ColorScheme.light(
      primary: AppColorsLight.primary,
      onPrimary: AppColorsLight.textOnPrimary,
      primaryContainer: AppColorsLight.primaryLight,
      secondary: AppColorsLight.secondary,
      onSecondary: AppColorsLight.textOnPrimary,
      secondaryContainer: AppColorsLight.secondaryLight,
      tertiary: AppColorsLight.accent,
      error: AppColorsLight.error,
      onError: Colors.white,
      surface: AppColorsLight.surface,
      onSurface: AppColorsLight.textPrimary,
      surfaceContainerHighest: AppColorsLight.surfaceVariant,
    ),

    // Scaffold
    scaffoldBackgroundColor: AppColorsLight.background,

    // AppBar Theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      iconTheme: IconThemeData(color: AppColorsLight.textPrimary),
      titleTextStyle: TextStyle(
        color: AppColorsLight.textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Card Theme
    cardTheme: CardTheme(
      color: AppColorsLight.cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColorsLight.cardBorder, width: 1),
      ),
      shadowColor: AppColorsLight.shadowLight,
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColorsLight.inputBackground,
      hintStyle: TextStyle(color: AppColorsLight.textTertiary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColorsLight.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColorsLight.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            BorderSide(color: AppColorsLight.inputFocusBorder, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColorsLight.error),
      ),
    ),

    // Text Theme
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColorsLight.textPrimary,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColorsLight.textPrimary,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColorsLight.textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColorsLight.textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColorsLight.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppColorsLight.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppColorsLight.textSecondary,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: AppColorsLight.textTertiary,
      ),
    ),

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorsLight.primary,
        foregroundColor: AppColorsLight.textOnPrimary,
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Icon Theme
    iconTheme: IconThemeData(
      color: AppColorsLight.textPrimary,
      size: 24,
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: AppColorsLight.divider,
      thickness: 1,
      space: 1,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Color Scheme
    colorScheme: ColorScheme.dark(
      primary: AppColorsDark.primary,
      onPrimary: AppColorsDark.textOnPrimary,
      primaryContainer: AppColorsDark.primaryLight,
      secondary: AppColorsDark.secondary,
      onSecondary: AppColorsDark.textOnPrimary,
      secondaryContainer: AppColorsDark.secondaryLight,
      tertiary: AppColorsDark.accent,
      error: AppColorsDark.error,
      onError: AppColorsDark.textOnPrimary,
      surface: AppColorsDark.surface,
      onSurface: AppColorsDark.textPrimary,
      surfaceContainerHighest: AppColorsDark.surfaceVariant,
    ),

    // Scaffold
    scaffoldBackgroundColor: AppColorsDark.background,

    // AppBar Theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: IconThemeData(color: AppColorsDark.textPrimary),
      titleTextStyle: TextStyle(
        color: AppColorsDark.textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Card Theme
    cardTheme: CardTheme(
      color: AppColorsDark.cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColorsDark.cardBorder, width: 1),
      ),
      shadowColor: AppColorsDark.shadowLight,
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColorsDark.inputBackground,
      hintStyle: TextStyle(color: AppColorsDark.textTertiary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColorsDark.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColorsDark.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColorsDark.inputFocusBorder, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColorsDark.error),
      ),
    ),

    // Text Theme
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColorsDark.textPrimary,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColorsDark.textPrimary,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColorsDark.textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColorsDark.textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColorsDark.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppColorsDark.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppColorsDark.textSecondary,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: AppColorsDark.textTertiary,
      ),
    ),

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorsDark.primary,
        foregroundColor: AppColorsDark.textOnPrimary,
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Icon Theme
    iconTheme: IconThemeData(
      color: AppColorsDark.textPrimary,
      size: 24,
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: AppColorsDark.divider,
      thickness: 1,
      space: 1,
    ),
  );
}
