import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/mock_stories.dart';
import '../../domain/story_group.dart';
import 'stories_state.dart';


class StoriesCubit extends Cubit<StoriesState> {
  StoriesCubit() : super(const StoriesState());

  /// Loads mock data and sorts the rail: unseen groups first, then seen,
  /// newest activity first within each band. Ordering is only recomputed here
  
  void load() {
    emit(state.copyWith(status: StoriesStatus.loading));
    try {
      final groups = mockStoryGroups()..sort(_compareGroups);
      emit(state.copyWith(status: StoriesStatus.success, groups: groups));
    } catch (e) {
      emit(state.copyWith(
        status: StoriesStatus.failure,
        failureMessage: e.toString(),
      ));
    }
  }

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
