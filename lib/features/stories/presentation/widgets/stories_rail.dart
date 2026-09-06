import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/stories_cubit.dart';
import '../cubit/stories_state.dart';
import 'story_avatar.dart';
import 'your_story_avatar.dart';

/// Horizontal rail under the app bar: "Your Story" first, then one avatar
/// per author group. Sits above the M2 post list in the Feed tab.
class StoriesRail extends StatefulWidget {
  const StoriesRail({super.key});

  static const String _viewerAvatarUrl = 'https://i.pravatar.cc/150?u=miracle.h';

  @override
  State<StoriesRail> createState() => _StoriesRailState();
}

class _StoriesRailState extends State<StoriesRail> {
  // Guards against a rapid double-tap pushing the viewer twice.
  bool _isNavigating = false;

  Future<void> _openViewer(int groupIndex) async {
    if (_isNavigating) return;
    _isNavigating = true;
    await context.push(AppRoutes.storyViewerPath(groupIndex));
    _isNavigating = false;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.storiesRailHeight,
      child: BlocBuilder<StoriesCubit, StoriesState>(
        builder: (context, state) {
          final groups = state.groups;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
              vertical: AppSpacing.s,
            ),
            itemCount: groups.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const Padding(
                  padding: EdgeInsets.only(right: AppSpacing.s),
                  child: YourStoryAvatar(
                    avatarUrl: StoriesRail._viewerAvatarUrl,
                  ),
                );
              }
              final groupIndex = index - 1;
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.s),
                child: StoryAvatar(
                  group: groups[groupIndex],
                  onTap: () => _openViewer(groupIndex),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Hairline separating the rail from the post list, matching the design's
/// flat, flush sections.
class StoriesRailDivider extends StatelessWidget {
  const StoriesRailDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.divider,
      child: SizedBox(height: AppSpacing.cardSeparator, width: double.infinity),
    );
  }
}
