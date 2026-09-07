import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/chip_styles.dart';
import '../../data/models/post_media.dart';
import '../../domain/enums.dart';

/// Post media carousel. Hidden entirely when there is no media.
///
/// Reserves its height via `AspectRatio` from the first item's aspect ratio
/// (default `16/10`) before any image loads — this is what stops the feed
/// juddering as it scrolls. Full-bleed: unlike the rest of the card, this is
/// the only element without the screen's horizontal margin.
class PostMediaView extends StatefulWidget {
  const PostMediaView({
    super.key,
    required this.media,
    required this.postType,
    this.transactionType,
    this.transactionLabel,
  });

  final List<PostMedia> media;
  final PostType postType;
  final TransactionType? transactionType;
  final String? transactionLabel;

  static const double _defaultAspectRatio = 16 / 10;

  @override
  State<PostMediaView> createState() => _PostMediaViewState();
}

class _PostMediaViewState extends State<PostMediaView> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.media.isEmpty) return const SizedBox.shrink();

    final double aspectRatio =
        widget.media.first.aspectRatio ?? PostMediaView._defaultAspectRatio;

    final ChipStyle? chipStyle =
        widget.postType == PostType.property && widget.transactionType != null
        ? kChipStyles[widget.transactionType!.apiValue]
        : null;
    final bool showTypeBadge =
        chipStyle != null && widget.transactionLabel != null;
    final bool showCounter = widget.media.length > 1;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: aspectRatio,
            child: Stack(
              children: [
                PageView.builder(
                  itemCount: widget.media.length,
                  onPageChanged: (page) => setState(() => _page = page),
                  itemBuilder: (context, index) =>
                      _MediaItem(media: widget.media[index]),
                ),
                if (showTypeBadge)
                  Positioned(
                    top: AppSpacing.s,
                    left: AppSpacing.s,
                    child: _TypeBadge(
                      icon: chipStyle.icon,
                      label: widget.transactionLabel!,
                    ),
                  ),
                if (showCounter)
                  Positioned(
                    top: AppSpacing.s,
                    right: AppSpacing.s,
                    child: _CounterBadge(
                      current: _page + 1,
                      total: widget.media.length,
                    ),
                  ),
              ],
            ),
          ),
          if (showCounter)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.s),
              child: _PageDots(count: widget.media.length, activeIndex: _page),
            ),
        ],
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs / 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.overlayScrim.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppSpacing.iconLocation,
            color: AppColors.overlayContent,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(label, style: AppTypography.durationBadge),
        ],
      ),
    );
  }
}

class _CounterBadge extends StatelessWidget {
  const _CounterBadge({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs / 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.overlayScrim.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Text('$current/$total', style: AppTypography.durationBadge),
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

        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.mediaDotGap,
          ),
          width:  AppSpacing.mediaDot,
          height:  AppSpacing.mediaDot,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? AppColors.primaryDeep : AppColors.textDisabled,
          ),
        );
      }),
    );
  }
}
