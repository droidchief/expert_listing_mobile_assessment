import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/number_format.dart';
import '../../../../core/widgets/app_icon_button.dart';
import '../../../../core/widgets/count_text.dart';
import '../../../comments/presentation/widgets/comments_sheet.dart';
import '../../data/models/post.dart';
import '../cubit/feed_cubit.dart';

class PostActionBar extends StatelessWidget {
  const PostActionBar({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final int viewCount = post.counts.views;
    final String views = formatCount(viewCount);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal - AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          _LikeButton(post: post),
          AppIconButton(
            iconAsset: 'assets/images/comment_icon.svg',
            count: post.counts.comments,
            semanticLabel: 'Comments',
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
          ),
          AppIconButton(
            iconAsset: 'assets/images/share_icon.svg',
            semanticLabel: 'Share',
            onTap: () => SharePlus.instance.share(
              ShareParams(
                text:
                    'Check out this listing on Expert Listing: '
                    'https://expertlisting.app/posts/${post.id}',
              ),
            ),
          ),
          if (viewCount > 0) ...[
            Text(
              '$views ${viewCount == 1 ? 'View' : 'Views'}',
              style: AppTypography.countLabel,
            ),
            const SizedBox(width: AppSpacing.s),
          ],
          const Spacer(),
          const _BookmarkButton(),
        ],
      ),
    );
  }
}

class _BookmarkButton extends StatefulWidget {
  const _BookmarkButton();

  @override
  State<_BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<_BookmarkButton> {
  bool _bookmarked = false;

  void _toggle() => setState(() => _bookmarked = !_bookmarked);

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      iconAsset: 'assets/images/bookmark_icon.svg',
      color: _bookmarked ? AppColors.primaryText : null,
      semanticLabel: 'Bookmark',
      onTap: _toggle,
    );
  }
}

class _LikeButton extends StatefulWidget {
  const _LikeButton({required this.post});

  final Post post;

  @override
  State<_LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<_LikeButton> {
  static const double _minTapTarget = 44;
  static const Duration _bumpLeg = Duration(milliseconds: 90);

  double _scale = 1.0;

  @override
  void didUpdateWidget(covariant _LikeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.viewerState.hasLiked !=
        widget.post.viewerState.hasLiked) {
      setState(() => _scale = 1.25);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasLiked = widget.post.viewerState.hasLiked;
    final int likes = widget.post.counts.likes;

    return Semantics(
      button: true,
      label: likes > 0 ? 'Like, $likes' : 'Like',
      child: InkWell(
        onTap: () {
          if (!hasLiked) HapticFeedback.heavyImpact();
          context.read<FeedCubit>().toggleLike(widget.post.id);
        },
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
                AnimatedScale(
                  scale: _scale,
                  duration: _bumpLeg,
                  curve: Curves.easeOutBack,
                  onEnd: () {
                    if (_scale != 1.0) setState(() => _scale = 1.0);
                  },
                  child: Icon(
                    hasLiked ? Icons.favorite : Icons.favorite_border,
                    size: AppSpacing.iconAction,
                    color: hasLiked
                        ? AppColors.likeActive
                        : AppColors.iconDefault,
                  ),
                ),
                if (likes > 0) ...[
                  const SizedBox(width: AppSpacing.xs),
                  CountText(likes),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
