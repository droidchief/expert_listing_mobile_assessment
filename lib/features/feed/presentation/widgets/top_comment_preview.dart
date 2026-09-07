import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../comments/presentation/widgets/comments_sheet.dart';
import '../../data/models/post.dart';
import '../cubit/feed_cubit.dart';

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
            GestureDetector(
              onTap: () {
                final feedCubit = context.read<FeedCubit>();
                showCommentsSheet(
                  context,
                  postId: post.id,
                  initialCommentCount: post.counts.comments,
                  onCommentCountChanged: (count) =>
                      feedCubit.updateCommentCount(post.id, count),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text(
                  'View all ${post.counts.comments} comments',
                  style: AppTypography.linkLabel,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
