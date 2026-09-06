import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../data/feed_repository.dart';
import '../../data/models/liked_by_preview.dart';
import '../../data/models/liked_by_user.dart';
import '../../data/models/post.dart';
import 'feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit(this._repository) : super(const FeedState());

  final FeedRepository _repository;

  // The seeded current user. A proper `/me` call replaces this later.
  static const String _currentUsername = 'miracle.h';
  static const String _currentUserAvatarUrl =
      'https://i.pravatar.cc/150?u=miracle.h';
  static const Duration _likeDebounce = Duration(milliseconds: 400);
  static const int _facepileCap = 3;

  final Map<String, Timer> _likeTimers = {};
  // The state a post was in before the current burst of taps started —
  // captured once per burst so a failure rolls all the way back to it,
  // not to whatever the previous optimistic frame happened to be.
  final Map<String, Post> _likeSnapshots = {};

  Future<void> loadInitial() async {
    emit(state.copyWith(status: FeedStatus.loading, clearFailure: true));
    try {
      final page = await _repository.getFeed();
      emit(state.copyWith(
        status: FeedStatus.success,
        posts: page.data,
        nextCursor: page.pagination.nextCursor,
        clearNextCursor: page.pagination.nextCursor == null,
        hasMore: page.pagination.hasMore,
      ));
    } on Failure catch (f) {
      emit(state.copyWith(status: FeedStatus.failure, failure: f));
    }
  }

  /// No-op unless the feed is loaded, has another page, and isn't already
  /// fetching one — the guard that stops a scroll listener from firing
  /// overlapping requests as the user keeps scrolling past the trigger
  /// point.
  Future<void> loadMore() async {
    if (!state.hasMore ||
        state.isLoadingMore ||
        state.status != FeedStatus.success) {
      return;
    }
    emit(state.copyWith(isLoadingMore: true, clearLoadMoreFailure: true));
    try {
      final page = await _repository.getFeed(cursor: state.nextCursor);
      emit(state.copyWith(
        posts: [...state.posts, ...page.data],
        nextCursor: page.pagination.nextCursor,
        clearNextCursor: page.pagination.nextCursor == null,
        hasMore: page.pagination.hasMore,
        isLoadingMore: false,
      ));
    } on Failure catch (f) {
      emit(state.copyWith(isLoadingMore: false, loadMoreFailure: f));
    }
  }

  /// Fetches page 1 without clearing what's already on screen; only
  /// replaces `posts` once the new page has actually arrived.
  Future<void> refresh() async {
    emit(state.copyWith(isRefreshing: true, clearLoadMoreFailure: true));
    try {
      final page = await _repository.getFeed();
      emit(state.copyWith(
        status: FeedStatus.success,
        posts: page.data,
        nextCursor: page.pagination.nextCursor,
        clearNextCursor: page.pagination.nextCursor == null,
        hasMore: page.pagination.hasMore,
        isRefreshing: false,
        clearFailure: true,
      ));
    } on Failure catch (f) {
      // Non-fatal, same as a load-more failure: the posts already on
      // screen are untouched, so this surfaces through the same inline
      // footer rather than replacing the list with an error screen.
      emit(state.copyWith(isRefreshing: false, loadMoreFailure: f));
    }
  }

  Future<void> retryLoadMore() async {
    emit(state.copyWith(clearLoadMoreFailure: true));
    await loadMore();
  }

  /// Optimistic like/unlike with rollback. Flips the heart immediately,
  /// then debounces 400ms per post id before calling the API with the
  /// *final* intended state — five rapid taps send one request, not five.
  Future<void> toggleLike(String postId) async {
    final int index = state.posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final Post current = state.posts[index];
    _likeSnapshots.putIfAbsent(postId, () => current);

    final bool desired = !current.viewerState.hasLiked;
    _applyOptimistic(index, current, desired);

    HapticFeedback.lightImpact();

    _likeTimers[postId]?.cancel();
    _likeTimers[postId] = Timer(_likeDebounce, () {
      _likeTimers.remove(postId);
      unawaited(_sendLike(postId, desired));
    });
  }

  void _applyOptimistic(int index, Post current, bool desired) {
    final Post optimistic = current.copyWith(
      viewerState: current.viewerState.copyWith(hasLiked: desired),
      counts: current.counts.copyWith(
        likes: current.counts.likes + (desired ? 1 : -1),
      ),
      likedByPreview: _adjustFacepile(current.likedByPreview, desired),
    );
    final posts = [...state.posts];
    posts[index] = optimistic;
    emit(state.copyWith(posts: posts));
  }

  Future<void> _sendLike(String postId, bool desired) async {
    try {
      final result = await _repository.setLike(postId: postId, liked: desired);
      _likeSnapshots.remove(postId);

      final int index = state.posts.indexWhere((p) => p.id == postId);
      if (index == -1) return;
      final Post reconciled = state.posts[index].copyWith(
        viewerState:
            state.posts[index].viewerState.copyWith(hasLiked: result.hasLiked),
        counts: state.posts[index].counts.copyWith(likes: result.likeCount),
      );
      final posts = [...state.posts];
      posts[index] = reconciled;
      emit(state.copyWith(posts: posts));
    } on Failure catch (f) {
      final Post? snapshot = _likeSnapshots.remove(postId);
      final int index = state.posts.indexWhere((p) => p.id == postId);
      if (snapshot != null && index != -1) {
        final posts = [...state.posts];
        posts[index] = snapshot;
        emit(state.copyWith(
          posts: posts,
          actionFailure: f,
          actionFailurePostId: postId,
        ));
      } else {
        emit(state.copyWith(actionFailure: f, actionFailurePostId: postId));
      }
    }
  }

  /// The API never returns an updated `liked_by_preview`, so the facepile
  /// is adjusted locally — a little drift against the server is fine and
  /// self-corrects on the next feed load.
  LikedByPreview _adjustFacepile(LikedByPreview preview, bool liked) {
    if (liked) {
      final bool alreadyPresent =
          preview.users.any((u) => u.username == _currentUsername);
      final List<LikedByUser> users = alreadyPresent
          ? preview.users
          : [
              const LikedByUser(
                username: _currentUsername,
                avatarUrl: _currentUserAvatarUrl,
              ),
              ...preview.users,
            ].take(_facepileCap).toList();
      return preview.copyWith(total: preview.total + 1, users: users);
    }

    final List<LikedByUser> users =
        preview.users.where((u) => u.username != _currentUsername).toList();
    return preview.copyWith(
      total: preview.total > 0 ? preview.total - 1 : 0,
      users: users,
    );
  }

  void clearActionFailure() => emit(state.copyWith(clearActionFailure: true));

  @override
  Future<void> close() {
    for (final timer in _likeTimers.values) {
      timer.cancel();
    }
    _likeTimers.clear();
    return super.close();
  }
}
