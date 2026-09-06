import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/relative_time.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_icon_button.dart';
import '../../data/models/post.dart';
import '../../domain/enums.dart';

/// Top section of a `PostCard`: avatar, name row (with an optional role
/// badge and verified tick), the post-type/relative-time meta line, and a
/// trailing overflow button.
class PostHeader extends StatelessWidget {
  const PostHeader({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final author = post.author;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppAvatar(
            size: AppSpacing.avatarPost,
            url: author.avatarUrl,
            name: author.displayName,
          ),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: author.displayName,
                        style: AppTypography.displayName,
                      ),
                      if (author.isVerified)
                        const WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Padding(
                            padding: EdgeInsets.only(left: AppSpacing.xs),
                            child: Icon(
                              Icons.verified,
                              size: 14,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      if (post.showRoleBadge && author.roleLabel != null)
                        TextSpan(
                          text: ' · ${author.roleLabel}',
                          style: AppTypography.roleBadge,
                        ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${post.postType.label} · '
                  '${relativeTime(post.createdAt.toLocal())}',
                  style: AppTypography.metaLine,
                ),
              ],
            ),
          ),
          const AppIconButton(
            icon: Icons.more_horiz,
            semanticLabel: 'More options',
          ),
        ],
      ),
    );
  }
}
