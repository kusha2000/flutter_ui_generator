import 'package:flutter/material.dart';

class AppColorsDark {
  // Primary Colors - Vibrant for Dark Mode
  static const Color primary = Color(0xFF818CF8); // Lighter Indigo for dark
  static const Color primaryLight = Color(0xFFA5B4FC);
  static const Color primaryDark = Color(0xFF6366F1);

  // Secondary Colors - Vibrant Purple/Pink
  static const Color secondary = Color(0xFFC084FC); // Lighter Purple
  static const Color secondaryLight = Color(0xFFE9D5FF);
  static const Color secondaryDark = Color(0xFFA855F7);

  // Accent Colors
  static const Color accent = Color(0xFFF472B6); // Lighter Pink
  static const Color accentLight = Color(0xFFFBBF24);

  // Background Colors - Dark theme
  static const Color background = Color(0xFF0F172A); // Deep dark blue
  static const Color surface = Color(0xFF1E293B); // Slightly lighter
  static const Color surfaceVariant = Color(0xFF334155);

  // Text Colors
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFF0F172A);

  // Status Colors - More vibrant for dark mode
  static const Color success = Color(0xFF34D399); // Brighter Emerald
  static const Color successLight = Color(0xFF6EE7B7);
  static const Color error = Color(0xFFF87171); // Brighter Red
  static const Color errorLight = Color(0xFFFCA5A5);
  static const Color warning = Color(0xFFFBBF24); // Brighter Amber
  static const Color warningLight = Color(0xFFFCD34D);
  static const Color info = Color(0xFF60A5FA); // Brighter Blue
  static const Color infoLight = Color(0xFF93C5FD);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF818CF8),
    Color(0xFFC084FC),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFFC084FC),
    Color(0xFFF472B6),
  ];

  static const List<Color> accentGradient = [
    Color(0xFF60A5FA),
    Color(0xFFA78BFA),
  ];

  // Card & Container Colors
  static const Color cardBackground = Color(0xFF1E293B);
  static const Color cardBorder = Color(0xFF334155);

  // Input Colors
  static const Color inputBackground = Color(0xFF334155);
  static const Color inputBorder = Color(0xFF475569);
  static const Color inputFocusBorder = Color(0xFF818CF8);

  // Shadow Colors
  static final Color shadowLight = Colors.black.withOpacity(0.2);
  static final Color shadowMedium = Colors.black.withOpacity(0.3);
  static final Color shadowHeavy = Colors.black.withOpacity(0.4);

  // Overlay Colors
  static final Color overlay = Colors.black.withOpacity(0.7);
  static final Color overlayLight = Colors.black.withOpacity(0.5);

  // Divider
  static const Color divider = Color(0xFF334155);
}
