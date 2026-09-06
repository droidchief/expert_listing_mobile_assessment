import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/post.dart';

/// Username and comment body on one wrapping line, plus a "View all N
/// comments" link. Hidden entirely when the post has no `topComment`.
class TopCommentPreview extends StatelessWidget {
  const TopCommentPreview({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final topComment = post.topComment;
    if (topComment == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${topComment.author.username}  ',
                  style: AppTypography.commentPreview.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: topComment.body,
                  style: AppTypography.commentPreview,
                ),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (post.counts.comments > 1)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                'View all ${post.counts.comments} comments',
                style: AppTypography.linkLabel,
              ),
            ),
        ],
      ),
    );
  }
}
