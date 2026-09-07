import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/chip_styles.dart';
import '../../data/models/post_media.dart';
import '../../domain/enums.dart';
import '../cubit/feed_cubit.dart';

/// Dedicated icon assets for the two most common transaction types — falls
/// back to the (Material icon) `ChipStyle.icon` for every other type.
const Map<TransactionType, String> _typeBadgeAssets = {
  TransactionType.forSale: 'assets/images/for_sale_icon.svg',
  TransactionType.forRent: 'assets/images/for_rent_icon.svg',
};

/// Post media carousel. Hidden entirely when there is no media.
///
/// Reserves its height via `AspectRatio` from the first item's aspect ratio
/// (default `16/10`) before any image loads — this is what stops the feed
/// juddering as it scrolls. Full-bleed: unlike the rest of the card, this is
/// the only element without the screen's horizontal margin.
class PostMediaView extends StatefulWidget {
  const PostMediaView({
    super.key,
    required this.postId,
    required this.hasLiked,
    required this.media,
    required this.postType,
    this.transactionType,
    this.transactionLabel,
  });

  final String postId;
  final bool hasLiked;
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
  int _heartBurstId = 0;

  void _handleDoubleTap() {
    // Instagram-style: double tap only ever likes, never unlikes — and only
    // the like transition gets a haptic bump.
    if (!widget.hasLiked) {
      HapticFeedback.heavyImpact();
      context.read<FeedCubit>().toggleLike(widget.postId);
    }
    setState(() => _heartBurstId++);
  }

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
            child: GestureDetector(
              onDoubleTap: _handleDoubleTap,
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
                      top: AppSpacing.m,
                      left: AppSpacing.s,
                      child: _TypeBadge(
                        iconAsset: _typeBadgeAssets[widget.transactionType],
                        icon: chipStyle.icon,
                        label: widget.transactionLabel!,
                      ),
                    ),
                  if (showCounter)
                    Positioned(
                      top: AppSpacing.m,
                      right: AppSpacing.s,
                      child: _CounterBadge(
                        current: _page + 1,
                        total: widget.media.length,
                      ),
                    ),
                  if (_heartBurstId > 0)
                    Center(
                      child: _DoubleTapHeart(key: ValueKey(_heartBurstId)),
                    ),
                ],
              ),
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

/// One-shot heart pop-and-fade shown at the centre of the media on double
/// tap. Recreated (via its `ValueKey`) on every double tap, which restarts
/// the animation from scratch.
class _DoubleTapHeart extends StatelessWidget {
  const _DoubleTapHeart({super.key});

  static const Duration _duration = Duration(milliseconds: 700);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: _duration,
        curve: Curves.linear,
        builder: (context, t, child) {
          final double scale = t < 0.4
              ? Curves.easeOutBack.transform(t / 0.4)
              : 1.0;
          final double opacity = t < 0.7 ? 1.0 : 1.0 - (t - 0.7) / 0.3;
          return Opacity(
            opacity: opacity.clamp(0.0, 1.0),
            child: Transform.scale(scale: scale, child: child),
          );
        },
        child: const Icon(
          Icons.favorite,
          color: AppColors.likeActive,
          size: 80,
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({this.iconAsset, required this.icon, required this.label});

  final String? iconAsset;
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
          if (iconAsset != null)
            SvgPicture.asset(
              iconAsset!,
              width: AppSpacing.iconLocation,
              height: AppSpacing.iconLocation,
              colorFilter: const ColorFilter.mode(
                AppColors.overlayContent,
                BlendMode.srcIn,
              ),
            )
          else
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
      padding: EdgeInsets.all(16),
      width: AppSpacing.mediaPlayButton,
      height: AppSpacing.mediaPlayButton,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.overlayScrim.withValues(alpha: 0.45),
      ),
      child: SvgPicture.asset(
        'assets/images/play_icon.svg',
        width: AppSpacing.mediaPlayIcon,
        height: AppSpacing.mediaPlayIcon,
        colorFilter: const ColorFilter.mode(
          AppColors.overlayContent,
          BlendMode.srcIn,
        ),
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
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/images/play_icon.svg',
            width: AppSpacing.iconLocation,
            height: AppSpacing.iconLocation,
            colorFilter: const ColorFilter.mode(
              AppColors.overlayContent,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(label, style: AppTypography.durationBadge),
        ],
      ),
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
          width: AppSpacing.mediaDot,
          height: AppSpacing.mediaDot,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? AppColors.primaryDeep : AppColors.textDisabled,
          ),
        );
      }),
    );
  }
}
