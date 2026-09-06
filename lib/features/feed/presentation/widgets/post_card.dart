import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/models/post.dart';
import 'liked_by_row.dart';
import 'post_action_bar.dart';
import 'post_body.dart';
import 'post_header.dart';
import 'post_location_row.dart';
import 'post_media_view.dart';
import 'top_comment_preview.dart';

/// A single post in the feed. Flat, flush section — no elevation, no
/// rounded corners, no margin — separated from the next card by a
/// full-bleed 1px divider.
class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: AppColors.surface,
          padding: const EdgeInsets.only(
            top: AppSpacing.cardPaddingTop,
            bottom: AppSpacing.cardPaddingBottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PostHeader(post: post),
              PostBody(body: post.body),
              PostLocationRow(post: post),
              PostMediaView(media: post.media),
              PostActionBar(post: post),
              LikedByRow(likedByPreview: post.likedByPreview),
              TopCommentPreview(post: post),
            ],
          ),
        ),
        const SizedBox(
          height: AppSpacing.cardSeparator,
          child: ColoredBox(color: AppColors.divider),
        ),
      ],
    );
  }
}
