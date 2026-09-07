import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/relative_time.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_icon_button.dart';
import '../../../stories/presentation/cubit/stories_cubit.dart';
import '../../../stories/presentation/cubit/stories_state.dart';
import '../../data/models/post.dart';
import '../../domain/enums.dart';
import 'post_location_row.dart';

class PostHeader extends StatelessWidget {
  const PostHeader({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final author = post.author;

    final StoriesState storiesState = context.watch<StoriesCubit>().state;
    final int storyGroupIndex = storiesState.groups.indexWhere(
      (group) => group.author.id == author.id,
    );
    final bool hasStory = storyGroupIndex != -1;

    // Reserve the same 8px the ring's border+gap adds, so a ringed avatar
    // still occupies exactly `avatarPost` overall — the same fix as
    // `YourStoryAvatar`'s ring alignment, applied here so ringed and
    // unringed post headers line up identically.
    Widget avatar = AppAvatar(
      size: hasStory ? AppSpacing.avatarPost - 8 : AppSpacing.avatarPost,
      url: author.avatarUrl,
      name: author.displayName,
      ringColor: hasStory
          ? (storiesState.groups[storyGroupIndex].hasUnseen
                ? AppColors.storyRingUnseen
                : AppColors.storyRingSeen)
          : null,
    );
    if (hasStory) {
      avatar = GestureDetector(
        onTap: () => context.push(AppRoutes.storyViewerPath(storyGroupIndex)),
        child: avatar,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          avatar,
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
                PostLocationRow(post: post),
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
