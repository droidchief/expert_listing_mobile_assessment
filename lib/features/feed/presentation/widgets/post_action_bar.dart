import 'package:flutter/material.dart';
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

/// Like / comment / share, then a spacer, then views and bookmark.
///
/// Like and comment are wired to the API (like optimistic via `FeedCubit`,
/// comments via their own sheet + `CommentsCubit`); share opens the OS share
/// sheet with a placeholder message and link (no real deep link exists yet);
/// bookmark is local UI-only state, not persisted or sent to the API.
class PostActionBar extends StatelessWidget {
  const PostActionBar({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final String views = formatViewCount(post.counts.views);

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
          const Spacer(),
          if (views.isNotEmpty) ...[
            Text('$views Views', style: AppTypography.countLabel),
            const SizedBox(width: AppSpacing.s),
          ],
          const _BookmarkButton(),
        ],
      ),
    );
  }
}

/// Local-only bookmark toggle — turns `primaryText` green when active, with
/// no backing API call and no count. Purely ephemeral UI state, so a
/// `StatefulWidget` is correct here; it starts unbookmarked on every build.
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

/// The heart button: mirrors `AppIconButton`'s layout (44x44 tap target,
/// same icon size, `CountText`) but adds a brief 1.0 → 1.25 → 1.0 scale
/// bump whenever `hasLiked` flips, in either direction. Purely a local
/// ephemeral animation, so a `StatefulWidget` is correct here.
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
        onTap: () => context.read<FeedCubit>().toggleLike(widget.post.id),
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
