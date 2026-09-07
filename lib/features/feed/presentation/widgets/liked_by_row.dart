import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../data/models/liked_by_preview.dart';


class LikedByRow extends StatelessWidget {
  const LikedByRow({super.key, required this.likedByPreview});

  final LikedByPreview likedByPreview;

  static const int _maxFacepile = 3;

  @override
  Widget build(BuildContext context) {
    final int total = likedByPreview.total;
    if (total <= 0) return const SizedBox.shrink();

    final users = likedByPreview.users;
    final int facepileCount = users.length.clamp(0, _maxFacepile);
    final String firstUsername = users.isNotEmpty ? users.first.username : '';

    final String text = switch (total) {
      1 => 'Liked by $firstUsername',
      2 => 'Liked by $firstUsername and 1 other',
      _ => 'Liked by $firstUsername and ${total - 1} others',
    };

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          SizedBox(
            width: facepileCount == 0
                ? 0
                : AppSpacing.avatarFacepile +
                      (facepileCount - 1) *
                          (AppSpacing.avatarFacepile +
                              AppSpacing.facepileOverlap),
            height: AppSpacing.avatarFacepile,
            child: Stack(
              children: [
                for (int i = 0; i < facepileCount; i++)
                  Positioned(
                    left:
                        i *
                        (AppSpacing.avatarFacepile +
                            AppSpacing.facepileOverlap),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.fromBorderSide(
                          BorderSide(color: AppColors.surface, width: 1.5),
                        ),
                      ),
                      child: AppAvatar(
                        size: AppSpacing.avatarFacepile,
                        url: users[i].avatarUrl,
                        name: users[i].username,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Text(
              text,
              style: AppTypography.metaLine,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
