import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// A shimmering placeholder shaped like `PostCard` — same section order
/// (header, body, location/chip, media, action bar, liked-by, top comment)
/// so the loading state reads as "this card, blank" rather than a generic
/// block. Bone widths/heights are decorative approximations of text-line
/// lengths, not real design tokens — anything that corresponds to an
/// actual layout dimension (avatar sizes, padding, media aspect ratio,
/// icon size) still comes from `AppSpacing`.
class FeedSkeletonList extends StatelessWidget {
  const FeedSkeletonList({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.skeletonBase,
      highlightColor: AppColors.skeletonHighlight,
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) => const _PostCardSkeleton(),
      ),
    );
  }
}

class _PostCardSkeleton extends StatelessWidget {
  const _PostCardSkeleton();

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
            children: const [
              _HeaderSkeleton(),
              SizedBox(height: AppSpacing.m),
              _BodySkeleton(),
              SizedBox(height: AppSpacing.m),
              _LocationRowSkeleton(),
              SizedBox(height: AppSpacing.s),
              _MediaSkeleton(),
              SizedBox(height: AppSpacing.xs),
              _ActionBarSkeleton(),
              SizedBox(height: AppSpacing.s),
              _LikedByRowSkeleton(),
              SizedBox(height: AppSpacing.s),
              _TopCommentSkeleton(),
            ],
          ),
        ),
        const _CardDivider(),
      ],
    );
  }
}

class _HeaderSkeleton extends StatelessWidget {
  const _HeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Bone(
            width: AppSpacing.avatarPost,
            height: AppSpacing.avatarPost,
            radius: AppSpacing.avatarPost / 2,
          ),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _Bone(width: 120, height: 14),
                SizedBox(height: AppSpacing.xs),
                _Bone(width: 90, height: 12),
              ],
            ),
          ),
          const _Bone(width: 18, height: 18, radius: 4),
        ],
      ),
    );
  }
}

class _BodySkeleton extends StatelessWidget {
  const _BodySkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Bone(height: 14),
          SizedBox(height: AppSpacing.xs),
          _Bone(width: 220, height: 14),
        ],
      ),
    );
  }
}

class _LocationRowSkeleton extends StatelessWidget {
  const _LocationRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
      ),
      child: Row(
        children: [
          const _Bone(
            width: AppSpacing.iconLocation,
            height: AppSpacing.iconLocation,
            radius: 3,
          ),
          const SizedBox(width: AppSpacing.xs),
          const _Bone(width: 130, height: 12),
          const Spacer(),
          _Bone(
            width: 90,
            height: 22,
            radius: AppSpacing.radiusChip,
          ),
        ],
      ),
    );
  }
}

class _MediaSkeleton extends StatelessWidget {
  const _MediaSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
      ),
      child: const AspectRatio(
        aspectRatio: 16 / 10,
        child: _Bone(
          width: double.infinity,
          height: double.infinity,
          radius: AppSpacing.radiusMedia,
        ),
      ),
    );
  }
}

class _ActionBarSkeleton extends StatelessWidget {
  const _ActionBarSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal - AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: const [
          _Bone(
            width: AppSpacing.iconAction,
            height: AppSpacing.iconAction,
            radius: 4,
          ),
          SizedBox(width: AppSpacing.l),
          _Bone(
            width: AppSpacing.iconAction,
            height: AppSpacing.iconAction,
            radius: 4,
          ),
          SizedBox(width: AppSpacing.l),
          _Bone(
            width: AppSpacing.iconAction,
            height: AppSpacing.iconAction,
            radius: 4,
          ),
          Spacer(),
          _Bone(
            width: AppSpacing.iconAction,
            height: AppSpacing.iconAction,
            radius: 4,
          ),
        ],
      ),
    );
  }
}

class _LikedByRowSkeleton extends StatelessWidget {
  const _LikedByRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
      ),
      child: Row(
        children: [
          const _Bone(
            width: AppSpacing.avatarFacepile,
            height: AppSpacing.avatarFacepile,
            radius: AppSpacing.avatarFacepile / 2,
          ),
          const SizedBox(width: AppSpacing.s),
          const _Bone(width: 160, height: 12),
        ],
      ),
    );
  }
}

class _TopCommentSkeleton extends StatelessWidget {
  const _TopCommentSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Bone(height: 14),
          SizedBox(height: AppSpacing.xs),
          _Bone(width: 100, height: 12),
        ],
      ),
    );
  }
}

class _Bone extends StatelessWidget {
  const _Bone({this.width, required this.height, this.radius = 4});

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.skeletonBase,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _CardDivider extends StatelessWidget {
  const _CardDivider();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: AppSpacing.cardSeparator,
      child: ColoredBox(color: AppColors.divider),
    );
  }
}
