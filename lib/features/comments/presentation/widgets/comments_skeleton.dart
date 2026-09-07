import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';


class CommentsSkeletonList extends StatelessWidget {
  const CommentsSkeletonList({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.skeletonBase,
      highlightColor: AppColors.skeletonHighlight,
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) => const _CommentRowSkeleton(),
      ),
    );
  }
}

class _CommentRowSkeleton extends StatelessWidget {
  const _CommentRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.m,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Bone(
            width: AppSpacing.avatarCommentRoot,
            height: AppSpacing.avatarCommentRoot,
            radius: AppSpacing.avatarCommentRoot / 2,
          ),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _Bone(width: 110, height: 13),
                SizedBox(height: AppSpacing.s),
                _Bone(height: 13),
                SizedBox(height: AppSpacing.xs),
                _Bone(width: 180, height: 13),
              ],
            ),
          ),
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
