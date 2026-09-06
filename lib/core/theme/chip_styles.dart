import 'package:flutter/material.dart';

/// Style for a single transaction chip: a foreground colour used for the
/// text/icon/border, a subtle tinted background, and a small leading icon.
class ChipStyle {
  const ChipStyle({
    required this.foreground,
    required this.background,
    required this.icon,
  });

  final Color foreground;
  final Color background;
  final IconData icon;
}

/// Keyed by the API's `transaction_type` enum string so M2 can look styles
/// up directly from the response value with no translation layer.
const Map<String, ChipStyle> kChipStyles = {
  'for_sale': ChipStyle(
    foreground: Color(0xFF2563EB),
    background: Color(0xFFEAF2FF),
    icon: Icons.sell_outlined,
  ),
  'for_rent': ChipStyle(
    foreground: Color(0xFF16A34A),
    background: Color(0xFFE8F6EE),
    icon: Icons.vpn_key_outlined,
  ),
  'for_shortlet': ChipStyle(
    foreground: Color(0xFF0D9488),
    background: Color(0xFFE6F5F3),
    icon: Icons.hotel_outlined,
  ),
  'looking_to_buy': ChipStyle(
    foreground: Color(0xFF7C3AED),
    background: Color(0xFFF3EBFF),
    icon: Icons.search,
  ),
  'looking_to_rent': ChipStyle(
    foreground: Color(0xFFD97706),
    background: Color(0xFFFEF3E2),
    icon: Icons.search,
  ),
  'looking_for_shortlet': ChipStyle(
    foreground: Color(0xFFD97706),
    background: Color(0xFFFEF3E2),
    icon: Icons.search,
  ),
};
