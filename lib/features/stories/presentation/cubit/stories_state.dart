import 'package:equatable/equatable.dart';

import '../../domain/story_group.dart';

enum StoriesStatus { initial, loading, success, failure }

class StoriesState extends Equatable {
  const StoriesState({
    this.status = StoriesStatus.initial,
    this.groups = const [],
    this.failureMessage,
  });

  final StoriesStatus status;
  final List<StoryGroup> groups;
  final String? failureMessage;

  StoriesState copyWith({
    StoriesStatus? status,
    List<StoryGroup>? groups,
    String? failureMessage,
  }) =>
      StoriesState(
        status: status ?? this.status,
        groups: groups ?? this.groups,
        failureMessage: failureMessage ?? this.failureMessage,
      );

  @override
  List<Object?> get props => [status, groups, failureMessage];
}
