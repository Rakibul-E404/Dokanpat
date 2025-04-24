import 'package:flutter/material.dart';

class AppColors {
  // Primary and secondary
  static const Color primary = Color(0xFF0A8754); // Deep green
  static const Color secondary = Color(0xFF00BFA6); // Teal-ish

  // Backgrounds
  static const Color background = Color(0xFFF5F5F5); // Light grey
  static const Color cardBackground = Colors.white;

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);

  // Accent colors
  static const Color accent = Color(0xFFFFC107); // Amber
  static const Color error = Color(0xFFB00020); // Red for errors

  // Icon colors
  static const Color favoriteFilled = Colors.red;
  static const Color favoriteBorder = Colors.grey;

  // Transparent overlays
  static Color overlayWhite80 = Colors.white.withOpacity(0.8);
}
