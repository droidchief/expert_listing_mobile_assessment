import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../data/comments_repository.dart';
import '../../data/models/comment.dart';
import '../../data/models/comment_author.dart';
import '../../data/models/comment_counts.dart';
import '../../data/models/comment_viewer_state.dart';
import 'comment_item.dart';
import 'comments_state.dart';


class CommentsCubit extends Cubit<CommentsState> {
  CommentsCubit({
    required String postId,
    required CommentsRepository repository,
    this.onCommentCountChanged,
  })  : _postId = postId,
        _repository = repository,
        super(const CommentsState());

  final String _postId;
  final CommentsRepository _repository;
  final void Function(int newCommentCount)? onCommentCountChanged;

  static const String _currentUserId = '00000000-0000-0000-0000-000000000001';
  static const String _currentUsername = 'miracle.h';
  static const String _currentDisplayName = 'Miracle H';
  static const String _currentAvatarUrl =
      'https://i.pravatar.cc/150?u=miracle.h';

  int _inFlightSends = 0;

  Future<void> load() async {
    emit(state.copyWith(status: CommentsStatus.loading, clearFailure: true));
    try {
      final page = await _repository.getComments(postId: _postId);
      emit(state.copyWith(
        status: CommentsStatus.success,
        comments: [for (final c in page.data) CommentItem(comment: c)],
        nextCursor: page.pagination.nextCursor,
        clearNextCursor: page.pagination.nextCursor == null,
        hasMore: page.pagination.hasMore,
      ));
    } on Failure catch (f) {
      emit(state.copyWith(status: CommentsStatus.failure, failure: f));
    }
  }

  
  Future<void> loadMore() async {
    if (!state.hasMore ||
        state.isLoadingMore ||
        state.status != CommentsStatus.success) {
      return;
    }
    emit(state.copyWith(isLoadingMore: true, clearLoadMoreFailure: true));
    try {
      final page =
          await _repository.getComments(postId: _postId, cursor: state.nextCursor);
      emit(state.copyWith(
        comments: [
          ...state.comments,
          for (final c in page.data) CommentItem(comment: c),
        ],
        nextCursor: page.pagination.nextCursor,
        clearNextCursor: page.pagination.nextCursor == null,
        hasMore: page.pagination.hasMore,
        isLoadingMore: false,
      ));
    } on Failure catch (f) {
      emit(state.copyWith(isLoadingMore: false, loadMoreFailure: f));
    }
  }


  Future<void> send(String body) async {
    final String trimmed = body.trim();
    if (trimmed.isEmpty) return;

    final String clientToken = _generateClientToken();
    final CommentItem pendingItem = CommentItem(
      comment: _buildPendingComment(clientToken, trimmed),
      sendState: CommentSendState.pending,
      clientToken: clientToken,
    );
    emit(state.copyWith(comments: [pendingItem, ...state.comments]));

    await _submit(clientToken, trimmed);
  }

  Future<void> retry(String clientToken) async {
    final int index = state.comments.indexWhere((c) => c.clientToken == clientToken);
    if (index == -1) return;

    final String body = state.comments[index].comment.body;
    final comments = [...state.comments];
    comments[index] =
        comments[index].copyWith(sendState: CommentSendState.pending);
    emit(state.copyWith(comments: comments));

    await _submit(clientToken, body);
  }

  void removeFailed(String clientToken) {
    emit(state.copyWith(
      comments:
          state.comments.where((c) => c.clientToken != clientToken).toList(),
    ));
  }

  Future<void> _submit(String clientToken, String body) async {
    _inFlightSends++;
    emit(state.copyWith(isSending: true));
    try {
      final result = await _repository.createComment(
        postId: _postId,
        body: body,
        clientToken: clientToken,
      );
      emit(state.copyWith(
        comments: [
          for (final item in state.comments)
            if (item.clientToken == clientToken)
              CommentItem(
                comment: result.comment,
                clientToken: clientToken,
              )
            else
              item,
        ],
      ));
      onCommentCountChanged?.call(result.postCommentCount);
    } on Failure catch (_) {
      emit(state.copyWith(
        comments: [
          for (final item in state.comments)
            if (item.clientToken == clientToken)
              item.copyWith(sendState: CommentSendState.failed)
            else
              item,
        ],
      ));
    } finally {
      _inFlightSends--;
      emit(state.copyWith(isSending: _inFlightSends > 0));
    }
  }

  Comment _buildPendingComment(String clientToken, String body) => Comment(
        id: clientToken,
        postId: _postId,
        body: body,
        author: const CommentAuthor(
          id: _currentUserId,
          username: _currentUsername,
          displayName: _currentDisplayName,
          avatarUrl: _currentAvatarUrl,
          isVerified: false,
        ),
        counts: const CommentCounts(likes: 0, replies: 0),
        viewerState: const CommentViewerState(isAuthor: true),
        isEdited: false,
        createdAt: DateTime.now().toUtc(),
      );

  String _generateClientToken() =>
      '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(1 << 32)}';
}
