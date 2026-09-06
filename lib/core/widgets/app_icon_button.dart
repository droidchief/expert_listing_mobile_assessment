import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'count_text.dart';

/// Icon plus an optional count, used in the post action bar. Achieves a
/// minimum 44x44 tap target via padding rather than inflating the icon.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    this.count = 0,
    this.color,
    this.onTap,
    required this.semanticLabel,
  });

  final IconData icon;
  final int count;
  final Color? color;
  final VoidCallback? onTap;
  final String semanticLabel;

  static const double _minTapTarget = 44;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: count > 0 ? '$semanticLabel, $count' : semanticLabel,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: _minTapTarget,
            minHeight: _minTapTarget,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: AppSpacing.iconAction,
                  color: color ?? AppColors.iconDefault,
                ),
                if (count > 0) ...[
                  const SizedBox(width: AppSpacing.xs),
                  CountText(count),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
