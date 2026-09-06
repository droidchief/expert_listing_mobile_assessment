import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/post_media.dart';
import '../../domain/enums.dart';

/// Post media carousel. Hidden entirely when there is no media.
///
/// Reserves its height via `AspectRatio` from the first item's aspect ratio
/// (default `16/10`) before any image loads — this is what stops the feed
/// juddering as it scrolls.
class PostMediaView extends StatefulWidget {
  const PostMediaView({super.key, required this.media});

  final List<PostMedia> media;

  static const double _defaultAspectRatio = 16 / 10;

  @override
  State<PostMediaView> createState() => _PostMediaViewState();
}

class _PostMediaViewState extends State<PostMediaView> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.media.isEmpty) return const SizedBox.shrink();

    final double aspectRatio = widget.media.first.aspectRatio ??
        PostMediaView._defaultAspectRatio;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.s,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedia),
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Stack(
            children: [
              PageView.builder(
                itemCount: widget.media.length,
                onPageChanged: (page) => setState(() => _page = page),
                itemBuilder: (context, index) =>
                    _MediaItem(media: widget.media[index]),
              ),
              if (widget.media.length > 1)
                Positioned(
                  bottom: AppSpacing.s,
                  left: 0,
                  right: 0,
                  child: _PageDots(
                    count: widget.media.length,
                    activeIndex: _page,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MediaItem extends StatelessWidget {
  const _MediaItem({required this.media});

  final PostMedia media;

  @override
  Widget build(BuildContext context) {
    final bool isVideo = media.mediaType == MediaType.video;
    final String? imageUrl = isVideo ? media.thumbnailUrl : media.url;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (imageUrl == null)
          Container(color: AppColors.divider)
        else
          CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, _) => Container(color: AppColors.divider),
            errorWidget: (context, url, error) =>
                Container(color: AppColors.divider),
          ),
        if (isVideo) ...[
          const Center(child: _PlayButton()),
          if (media.durationSeconds != null)
            Positioned(
              left: AppSpacing.s,
              bottom: AppSpacing.s,
              child: _DurationBadge(seconds: media.durationSeconds!),
            ),
        ],
      ],
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.mediaPlayButton,
      height: AppSpacing.mediaPlayButton,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.overlayScrim.withValues(alpha: 0.45),
      ),
      child: const Icon(
        Icons.play_arrow,
        color: AppColors.overlayContent,
        size: AppSpacing.mediaPlayIcon,
      ),
    );
  }
}

class _DurationBadge extends StatelessWidget {
  const _DurationBadge({required this.seconds});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    final String label =
        '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs / 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.overlayScrim.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppSpacing.xs),
      ),
      child: Text(label, style: AppTypography.durationBadge),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.activeIndex});

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final bool active = index == activeIndex;
        final double size =
            active ? AppSpacing.mediaDotActive : AppSpacing.mediaDot;
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.mediaDotGap,
          ),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? AppColors.overlayContent
                : AppColors.overlayContent.withValues(alpha: 0.5),
          ),
        );
      }),
    );
  }
}
