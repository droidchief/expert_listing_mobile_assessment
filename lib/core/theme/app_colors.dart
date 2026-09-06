import 'package:flutter/material.dart';

/// Every colour used across the app lives here. No widget should ever
/// contain a hex literal — read from these tokens instead.
abstract final class AppColors {
  static const Color primary = Color(0xFF0B7A43);
  static const Color primaryContainer = Color(0xFFE6F4EC);

  static const Color storyRingUnseen = Color(0xFF3FA34D);
  static const Color storyRingSeen = Color(0xFFD9D9D9);

  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFFFFFF);

  static const Color divider = Color(0xFFEFEFEF);
  static const Color border = Color(0xFFE5E7EB);

  static const Color textPrimary = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);

  static const Color iconDefault = Color(0xFF1F2937);

  static const Color fieldBackground = Color(0xFFF5F5F5);

  static const Color likeActive = Color(0xFFEF4444);
  static const Color error = Color(0xFFDC2626);
}
