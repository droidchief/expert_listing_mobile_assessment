import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../domain/story_group.dart';

class StoryAvatar extends StatelessWidget {
  const StoryAvatar({super.key, required this.group, required this.onTap});

  final StoryGroup group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.avatarStory + AppSpacing.s,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            AppAvatar(
              size: AppSpacing.avatarStory,
              url: group.author.avatarUrl,
              name: group.author.displayName,
              ringColor: group.hasUnseen
                  ? AppColors.storyRingUnseen
                  : AppColors.storyRingSeen,
              badge: group.author.isBusiness ? const _BusinessBadge() : null,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              group.author.displayName,
              style: AppTypography.storyLabel.copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _BusinessBadge extends StatelessWidget {
  const _BusinessBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.storyBadgeSize,
      height: AppSpacing.storyBadgeSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
        border: Border.all(color: AppColors.surface, width: 2),
      ),
      child: const Icon(
        Icons.storefront,
        size: AppSpacing.storyBadgeSize - 8,
        color: AppColors.surface,
      ),
    );
  }
}
