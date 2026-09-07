import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'count_text.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    this.icon,
    this.iconAsset,
    this.count = 0,
    this.color,
    this.onTap,
    required this.semanticLabel,
  }) : assert(
         (icon == null) != (iconAsset == null),
         'Provide exactly one of icon or iconAsset.',
       );

  final IconData? icon;
  final String? iconAsset;
  final int count;
  final Color? color;
  final VoidCallback? onTap;
  final String semanticLabel;

  static const double _minTapTarget = 44;

  @override
  Widget build(BuildContext context) {
    final Color resolvedColor = color ?? AppColors.iconDefault;

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
                if (iconAsset != null)
                  SvgPicture.asset(
                    iconAsset!,
                    width: AppSpacing.iconAction,
                    height: AppSpacing.iconAction,
                    colorFilter: ColorFilter.mode(
                      resolvedColor,
                      BlendMode.srcIn,
                    ),
                  )
                else
                  Icon(icon, size: AppSpacing.iconAction, color: resolvedColor),
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
