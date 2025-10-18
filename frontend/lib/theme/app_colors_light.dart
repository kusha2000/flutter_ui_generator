import 'package:flutter/material.dart';

class AppColorsLight {
  // Primary Colors - Modern Blue/Purple Gradient Theme
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Secondary Colors - Vibrant Purple/Pink
  static const Color secondary = Color(0xFFA855F7); // Purple
  static const Color secondaryLight = Color(0xFFC084FC);
  static const Color secondaryDark = Color(0xFF9333EA);

  // Accent Colors
  static const Color accent = Color(0xFFEC4899); // Pink
  static const Color accentLight = Color(0xFFF472B6);

  // Background Colors
  static const Color background = Color(0xFFF8FAFC); // Light blue-gray
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color successLight = Color(0xFF34D399);
  static const Color error = Color(0xFFEF4444); // Red
  static const Color errorLight = Color(0xFFF87171);
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color info = Color(0xFF3B82F6); // Blue
  static const Color infoLight = Color(0xFF60A5FA);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF6366F1),
    Color(0xFFA855F7),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFFA855F7),
    Color(0xFFEC4899),
  ];

  static const List<Color> accentGradient = [
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
  ];

  // Card & Container Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE2E8F0);

  // Input Colors
  static const Color inputBackground = Color(0xFFF8FAFC);
  static const Color inputBorder = Color(0xFFE2E8F0);
  static const Color inputFocusBorder = Color(0xFF6366F1);

  // Shadow Colors
  static final Color shadowLight = Colors.black.withOpacity(0.05);
  static final Color shadowMedium = Colors.black.withOpacity(0.1);
  static final Color shadowHeavy = Colors.black.withOpacity(0.15);

  // Overlay Colors
  static final Color overlay = Colors.black.withOpacity(0.5);
  static final Color overlayLight = Colors.black.withOpacity(0.3);

  // Divider
  static const Color divider = Color(0xFFE2E8F0);
}
