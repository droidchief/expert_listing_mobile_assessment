import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/post.dart';

enum FeedStatus { initial, loading, success, failure }

class FeedState extends Equatable {
  const FeedState({
    this.status = FeedStatus.initial,
    this.posts = const [],
    this.nextCursor,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.failure,
    this.loadMoreFailure,
    this.actionFailure,
    this.actionFailurePostId,
  });

  final FeedStatus status;
  final List<Post> posts;
  final String? nextCursor;
  final bool hasMore;
  final bool isLoadingMore;
  final bool isRefreshing;

  /// Fatal — the first page failed. Replaces the screen.
  final Failure? failure;

  /// Non-fatal — page N failed. The posts already on screen stay; this
  /// only drives an inline footer error.
  final Failure? loadMoreFailure;

  /// Transient — a single card action (like) failed after the optimistic
  /// update was already rolled back. Consumed once (e.g. as a SnackBar)
  /// and cleared, so it doesn't re-fire on every rebuild.
  final Failure? actionFailure;

  /// The post id `actionFailure` belongs to, so a Retry action knows what
  /// to retry.
  final String? actionFailurePostId;

  FeedState copyWith({
    FeedStatus? status,
    List<Post>? posts,
    String? nextCursor,
    bool clearNextCursor = false,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isRefreshing,
    Failure? failure,
    bool clearFailure = false,
    Failure? loadMoreFailure,
    bool clearLoadMoreFailure = false,
    Failure? actionFailure,
    bool clearActionFailure = false,
    String? actionFailurePostId,
  }) =>
      FeedState(
        status: status ?? this.status,
        posts: posts ?? this.posts,
        nextCursor: clearNextCursor ? null : (nextCursor ?? this.nextCursor),
        hasMore: hasMore ?? this.hasMore,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        isRefreshing: isRefreshing ?? this.isRefreshing,
        failure: clearFailure ? null : (failure ?? this.failure),
        loadMoreFailure: clearLoadMoreFailure
            ? null
            : (loadMoreFailure ?? this.loadMoreFailure),
        actionFailure: clearActionFailure
            ? null
            : (actionFailure ?? this.actionFailure),
        actionFailurePostId: clearActionFailure
            ? null
            : (actionFailurePostId ?? this.actionFailurePostId),
      );

  @override
  List<Object?> get props => [
        status,
        posts,
        nextCursor,
        hasMore,
        isLoadingMore,
        isRefreshing,
        failure,
        loadMoreFailure,
        actionFailure,
        actionFailurePostId,
      ];
}
