import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/chip_styles.dart';

/// Pill used for transaction chips (e.g. "For Sale", "Looking to Rent").
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    required this.style,
    this.icon,
  });

  final String label;
  final ChipStyle style;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
        border: Border.all(color: style.foreground.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: style.foreground),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: AppTypography.chipLabel.copyWith(color: style.foreground),
          ),
        ],
      ),
    );
  }
}
