import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/relative_time.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../domain/story_author.dart';

class StoryHeader extends StatelessWidget {
  const StoryHeader({
    super.key,
    required this.author,
    required this.createdAt,
    required this.onClose,
  });

  final StoryAuthor author;
  final DateTime createdAt;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        AppSpacing.s,
        AppSpacing.s,
        AppSpacing.l,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.overlayScrim.withValues(alpha: 0.55),
            AppColors.overlayScrim.withValues(alpha: 0),
          ],
        ),
      ),
      child: Row(
        children: [
          AppAvatar(
            size: AppSpacing.storyHeaderAvatar,
            url: author.avatarUrl,
            name: author.displayName,
          ),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    author.displayName,
                    style: AppTypography.storyUsername,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  relativeTime(createdAt.toLocal()),
                  style: AppTypography.storyMeta.copyWith(
                    color: AppColors.overlayContent.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.overlayContent),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
