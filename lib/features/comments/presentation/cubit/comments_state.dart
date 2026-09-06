import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import 'comment_item.dart';

enum CommentsStatus { initial, loading, success, failure }

class CommentsState extends Equatable {
  const CommentsState({
    this.status = CommentsStatus.initial,
    this.comments = const [],
    this.nextCursor,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.failure,
    this.loadMoreFailure,
    this.isSending = false,
  });

  final CommentsStatus status;
  final List<CommentItem> comments;
  final String? nextCursor;
  final bool hasMore;
  final bool isLoadingMore;

  /// Fatal — the first load failed.
  final Failure? failure;

  /// Non-fatal — page N failed. The list already on screen stays.
  final Failure? loadMoreFailure;

  final bool isSending;

  CommentsState copyWith({
    CommentsStatus? status,
    List<CommentItem>? comments,
    String? nextCursor,
    bool clearNextCursor = false,
    bool? hasMore,
    bool? isLoadingMore,
    Failure? failure,
    bool clearFailure = false,
    Failure? loadMoreFailure,
    bool clearLoadMoreFailure = false,
    bool? isSending,
  }) =>
      CommentsState(
        status: status ?? this.status,
        comments: comments ?? this.comments,
        nextCursor: clearNextCursor ? null : (nextCursor ?? this.nextCursor),
        hasMore: hasMore ?? this.hasMore,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        failure: clearFailure ? null : (failure ?? this.failure),
        loadMoreFailure: clearLoadMoreFailure
            ? null
            : (loadMoreFailure ?? this.loadMoreFailure),
        isSending: isSending ?? this.isSending,
      );

  @override
  List<Object?> get props => [
        status,
        comments,
        nextCursor,
        hasMore,
        isLoadingMore,
        failure,
        loadMoreFailure,
        isSending,
      ];
}
