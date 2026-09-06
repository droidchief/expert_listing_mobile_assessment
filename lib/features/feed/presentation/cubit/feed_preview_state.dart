import 'package:equatable/equatable.dart';

import '../../data/models/post.dart';

enum FeedPreviewStatus { initial, loading, success, failure }

/// State for the temporary M2 preview screen. M3 replaces this with the
/// real feed assembly's own Cubit (pagination, refresh, etc.).
class FeedPreviewState extends Equatable {
  const FeedPreviewState({
    this.status = FeedPreviewStatus.initial,
    this.posts = const [],
    this.failureMessage,
  });

  final FeedPreviewStatus status;
  final List<Post> posts;
  final String? failureMessage;

  FeedPreviewState copyWith({
    FeedPreviewStatus? status,
    List<Post>? posts,
    String? failureMessage,
  }) =>
      FeedPreviewState(
        status: status ?? this.status,
        posts: posts ?? this.posts,
        failureMessage: failureMessage ?? this.failureMessage,
      );

  @override
  List<Object?> get props => [status, posts, failureMessage];
}
