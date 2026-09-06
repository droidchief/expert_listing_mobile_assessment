import 'package:flutter/material.dart';

/// Style for a single transaction chip: a foreground colour used for the
/// text/icon/border, and a subtle tinted background.
class ChipStyle {
  const ChipStyle({required this.foreground, required this.background});

  final Color foreground;
  final Color background;
}

/// Keyed by the API's `transaction_type` enum string so M2 can look styles
/// up directly from the response value with no translation layer.
const Map<String, ChipStyle> kChipStyles = {
  'for_sale': ChipStyle(
    foreground: Color(0xFF2563EB),
    background: Color(0xFFEAF2FF),
  ),
  'for_rent': ChipStyle(
    foreground: Color(0xFF16A34A),
    background: Color(0xFFE8F6EE),
  ),
  'for_shortlet': ChipStyle(
    foreground: Color(0xFF0D9488),
    background: Color(0xFFE6F5F3),
  ),
  'looking_to_buy': ChipStyle(
    foreground: Color(0xFF7C3AED),
    background: Color(0xFFF3EBFF),
  ),
  'looking_to_rent': ChipStyle(
    foreground: Color(0xFFD97706),
    background: Color(0xFFFEF3E2),
  ),
  'looking_for_shortlet': ChipStyle(
    foreground: Color(0xFFD97706),
    background: Color(0xFFFEF3E2),
  ),
};
