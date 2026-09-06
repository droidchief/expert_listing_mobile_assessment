import 'package:equatable/equatable.dart';

import '../../data/models/comment.dart';

enum CommentSendState { sent, pending, failed }

/// Wraps a [Comment] with local send state so an optimistically-inserted
/// (pending or failed) comment lives in the same list as ones the server
/// has confirmed.
class CommentItem extends Equatable {
  const CommentItem({
    required this.comment,
    this.sendState = CommentSendState.sent,
    this.clientToken,
  });

  final Comment comment;
  final CommentSendState sendState;

  /// Retained so a failed send can be retried with the *same* token.
  final String? clientToken;

  CommentItem copyWith({
    Comment? comment,
    CommentSendState? sendState,
    String? clientToken,
  }) =>
      CommentItem(
        comment: comment ?? this.comment,
        sendState: sendState ?? this.sendState,
        clientToken: clientToken ?? this.clientToken,
      );

  @override
  List<Object?> get props => [comment, sendState, clientToken];
}
