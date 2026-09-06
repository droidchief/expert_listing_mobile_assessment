import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/number_format.dart';
import '../../../../core/widgets/app_icon_button.dart';
import '../../data/models/post.dart';

/// Like / comment / share, then a spacer, then views and bookmark.
///
/// No taps do anything yet — M7 wires like; share and bookmark stay inert.
class PostActionBar extends StatelessWidget {
  const PostActionBar({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final bool hasLiked = post.viewerState.hasLiked;
    final String views = formatViewCount(post.counts.views);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal - AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          AppIconButton(
            icon: hasLiked ? Icons.favorite : Icons.favorite_border,
            color: hasLiked ? AppColors.likeActive : AppColors.iconDefault,
            count: post.counts.likes,
            semanticLabel: 'Like',
          ),
          AppIconButton(
            icon: Icons.mode_comment_outlined,
            count: post.counts.comments,
            semanticLabel: 'Comments',
          ),
          const AppIconButton(
            icon: Icons.send_outlined,
            semanticLabel: 'Share',
          ),
          const Spacer(),
          if (views.isNotEmpty) ...[
            Text('$views Views', style: AppTypography.countLabel),
            const SizedBox(width: AppSpacing.s),
          ],
          AppIconButton(
            icon: Icons.bookmark_border,
            count: post.counts.bookmarks,
            semanticLabel: 'Bookmark',
          ),
        ],
      ),
    );
  }
}
