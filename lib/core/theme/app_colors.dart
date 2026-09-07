import 'package:flutter/material.dart';

/// Every colour used across the app lives here. No widget should ever
/// contain a hex literal — read from these tokens instead.
abstract final class AppColors {
  static const Color primary = Color(0xFF105B48);
  static const Color primaryDeep = Color(0xFF2F4A12);
  static const Color primaryContainer = Color(0xFFE6F4EC);

  // Distinct from `primary` — used for the bottom nav's active tab
  // (icon + label) and its "Beta" badge, per the nav bar redesign.
  static const Color primaryText = Color(0xFF4F7A1F);

  // The bottom nav's own icon set ships pre-colored to this grey — used
  // for every inactive nav icon so all five look consistent regardless of
  // what each individual SVG happens to bake in.
  static const Color navIconInactive = Color(0xFF434343);

  static const Color storyRingUnseen = Color(0xFFA8DC66);
  static const Color storyRingSeen = Color(0xFFD9D9D9);

  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFFFFFF);

  static const Color divider = Color(0xFFEFEFEF);
  static const Color border = Color(0xFFE5E7EB);

  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textSecondaryDarker = Color(0xFF434343);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFF7C7C7C);

  static const Color iconDefault = Color(0xFF1F2937);

  static const Color fieldBackground = Color(0xFFF5F5F5);

  static const Color likeActive = Color(0xFFEF4444);
  static const Color error = Color(0xFFDC2626);

  // Overlay on top of media (video play button, duration badge) — fixed
  // black/white regardless of theme, since it sits on a photo, not a surface.
  static const Color overlayScrim = Color(0xFF000000);
  static const Color overlayContent = Color(0xFFFFFFFF);

  // Shimmer loading skeletons.
  static const Color skeletonBase = Color(0xFFECECEC);
  static const Color skeletonHighlight = Color(0xFFF7F7F7);
}
