import 'package:equatable/equatable.dart';

import 'story.dart';
import 'story_author.dart';

class StoryGroup extends Equatable {
  const StoryGroup({required this.author, required this.stories});

  final StoryAuthor author;
  final List<Story> stories;

  bool get hasUnseen => stories.any((story) => !story.isSeen);

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
