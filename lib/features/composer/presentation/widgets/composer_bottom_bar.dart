import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class ComposerBottomBar extends StatelessWidget {
  const ComposerBottomBar({
    super.key,
    required this.onAddPhoto,
    required this.onAddLocation,
  });

  final VoidCallback onAddPhoto;
  final VoidCallback onAddLocation;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
          vertical: AppSpacing.s,
        ),
        child: Row(
          children: [
            _BottomBarAction(
              icon: Icons.image_outlined,
              label: 'Photo',
              onTap: onAddPhoto,
            ),
            const SizedBox(width: AppSpacing.l),
            _BottomBarAction(
              icon: Icons.location_on_outlined,
              label: 'Location',
              onTap: onAddLocation,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBarAction extends StatelessWidget {
  const _BottomBarAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppSpacing.iconAction, color: AppColors.primary),
            const SizedBox(width: AppSpacing.xs),
            Text(label, style: AppTypography.metaLine),
          ],
        ),
      ),
    );
  }
}
