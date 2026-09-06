import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_avatar.dart';

/// Always first in the rail. No coloured ring, a green "+" badge at the
/// bottom-right. Tapping does nothing — story creation is out of scope.
class YourStoryAvatar extends StatelessWidget {
  const YourStoryAvatar({super.key, required this.avatarUrl});

  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.avatarStory + AppSpacing.s,
      child: Column(
        children: [
          AppAvatar(
            size: AppSpacing.avatarStory,
            url: avatarUrl,
            name: 'Your Story',
            badge: const _PlusBadge(),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Your Story',
            style: AppTypography.storyLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PlusBadge extends StatelessWidget {
  const _PlusBadge();

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
        Icons.add,
        size: AppSpacing.storyBadgeSize - 8,
        color: AppColors.surface,
      ),
    );
  }
}
