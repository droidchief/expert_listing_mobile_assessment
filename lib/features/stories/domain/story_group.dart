import 'package:equatable/equatable.dart';

import 'story.dart';
import 'story_author.dart';

/// One author's stories. The rail shows one entry per group.
class StoryGroup extends Equatable {
  const StoryGroup({required this.author, required this.stories});

  final StoryAuthor author;
  final List<Story> stories;

  bool get hasUnseen => stories.any((story) => !story.isSeen);

  /// Index of the first unseen story, or `0` if every story is seen (a
  /// fully-watched group replays from the start rather than getting stuck
  /// past its own end).
  int get firstUnseenIndex {
    final index = stories.indexWhere((story) => !story.isSeen);
    return index == -1 ? 0 : index;
  }

  StoryGroup copyWith({StoryAuthor? author, List<Story>? stories}) =>
      StoryGroup(
        author: author ?? this.author,
        stories: stories ?? this.stories,
      );

  @override
  List<Object?> get props => [author, stories];
}
