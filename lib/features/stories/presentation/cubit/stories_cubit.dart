import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../feed/data/models/post.dart';
import '../../../feed/data/models/post_media.dart';
import '../../../feed/domain/enums.dart';
import '../../data/mock_stories.dart';
import '../../domain/story.dart';
import '../../domain/story_author.dart';
import '../../domain/story_group.dart';
import 'stories_state.dart';

class StoriesCubit extends Cubit<StoriesState> {
  StoriesCubit() : super(const StoriesState());


  static const String _currentUsername = 'miracle.h';



  void load() {
    emit(state.copyWith(status: StoriesStatus.loading));
    try {
      final groups = mockStoryGroups()..sort(_compareGroups);
      emit(state.copyWith(status: StoriesStatus.success, groups: groups));
    } catch (e) {
      emit(
        state.copyWith(
          status: StoriesStatus.failure,
          failureMessage: e.toString(),
        ),
      );
    }
  }


  void addGuestGroupsFromPosts(List<Post> posts, {int maxGroups = 4}) {
    final Set<String> existingAuthorIds = state.groups
        .map((group) => group.author.id)
        .toSet();
    final List<StoryGroup> newGroups = [];

    for (final post in posts) {
      if (newGroups.length >= maxGroups) break;
      if (post.author.username == _currentUsername) continue;
      if (existingAuthorIds.contains(post.author.id)) continue;
      if (post.media.isEmpty) continue;

      final List<Story> stories = [
        for (int i = 0; i < post.media.length; i++)
          if (_storyImageUrl(post.media[i]) case final String url)
            Story(
              id: '${post.id}-guest-$i',
              imageUrl: url,
              createdAt: post.createdAt,
            ),
      ];
      if (stories.isEmpty) continue;

      existingAuthorIds.add(post.author.id);
      newGroups.add(
        StoryGroup(
          author: StoryAuthor(
            id: post.author.id,
            username: post.author.username,
            displayName: post.author.displayName,
            avatarUrl:
                post.author.avatarUrl ??
                'https://i.pravatar.cc/150?u=${post.author.username}',
            isVerified: post.author.isVerified,
            isBusiness: post.author.isBusiness,
          ),
          stories: stories,
        ),
      );
    }

    if (newGroups.isEmpty) return;
    final groups = [...state.groups, ...newGroups]..sort(_compareGroups);
    emit(state.copyWith(groups: groups));
  }

  static String? _storyImageUrl(PostMedia media) =>
      media.mediaType == MediaType.video ? media.thumbnailUrl : media.url;

  void markSeen(String authorId, String storyId) {
    final groups = [
      for (final group in state.groups)
        if (group.author.id == authorId)
          group.copyWith(
            stories: [
              for (final story in group.stories)
                if (story.id == storyId && !story.isSeen)
                  story.copyWith(isSeen: true)
                else
                  story,
            ],
          )
        else
          group,
    ];
    emit(state.copyWith(groups: groups));
  }

  static int _compareGroups(StoryGroup a, StoryGroup b) {
    if (a.hasUnseen != b.hasUnseen) {
      return a.hasUnseen ? -1 : 1;
    }
    return _mostRecent(b).compareTo(_mostRecent(a));
  }

  static DateTime _mostRecent(StoryGroup group) => group.stories
      .map((story) => story.createdAt)
      .reduce((a, b) => a.isAfter(b) ? a : b);
}
