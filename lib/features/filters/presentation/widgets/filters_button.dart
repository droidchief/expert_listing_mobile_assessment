import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class FiltersButton extends StatelessWidget {
  const FiltersButton({
    super.key,
    required this.activeCount,
    required this.onTap,
  });

  final int activeCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.tune,
              size: AppSpacing.iconLocation,
              color: AppColors.iconDefault,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text('Filters', style: AppTypography.metaLine.copyWith(
              fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondaryDarker
            )),
            if (activeCount > 0) ...[
              const SizedBox(width: AppSpacing.xs),
              _Badge(count: activeCount),
            ],
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      height: AppSpacing.storyBadgeSize - AppSpacing.xs,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Text(
        '$count',
        style: AppTypography.navLabel.copyWith(color: AppColors.overlayContent),
      ),
    );
  }
}
