import 'package:flutter/material.dart';

/// RoadMesh brand & semantic color system — matched to the live app's
/// actual UI (light map surface, green as the active/positive accent,
/// blue for the ego-vehicle marker, red reserved for collision alerts).
/// Drop this in lib/theme/app_colors.dart
class AppColors {
  AppColors._();

  // Primary / positive — route line, active buttons, links, "Go!", safe mesh nodes
  static const Color meshGreen = Color(0xFF22C55E);
  static const Color meshGreenDark = Color(0xFF16A34A); // pressed/text state

  // Ego vehicle / self — matches the blue car marker on the map
  static const Color vehicleBlue = Color(0xFF2563EB);

  // Alerts — reserved strictly for warnings, never used decoratively
  static const Color alertRed = Color(0xFFEF4444);
  static const Color alertRedTint = Color(0xFFFEE2E2); // alert card background
  static const Color warningAmber = Color(0xFFF59E0B);

  // Neutrals — matches the white cards / light gray map background
  static const Color surface = Color(0xFFFFFFFF);
  static const Color mapBackground = Color(0xFFE7ECF2);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color lineStructure = Color(0xFF334155); // mesh/road line color

  // Dark-mode variants (the app has a dark-mode map toggle)
  static const Color darkSurface = Color(0xFF0F172A);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  static const RadialGradient iconBackground = RadialGradient(
    center: Alignment(0, -0.24),
    radius: 0.9,
    colors: [surface, mapBackground],
  );
}
