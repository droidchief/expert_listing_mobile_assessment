import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'comment_author.dart';
import 'comment_counts.dart';
import 'comment_viewer_state.dart';
import 'reply_preview.dart';

part 'comment.g.dart';

List<ReplyPreview> _repliesFromJson(List<dynamic>? json) =>
    json
        ?.map((e) => ReplyPreview.fromJson(e as Map<String, dynamic>))
        .toList() ??
    const [];

List<Map<String, dynamic>> _repliesToJson(List<ReplyPreview> replies) =>
    replies.map((e) => e.toJson()).toList();

@JsonSerializable()
class Comment extends Equatable {
  const Comment({
    required this.id,
    required this.postId,
    required this.body,
    required this.author,
    required this.counts,
    required this.viewerState,
    this.repliesPreview = const [],
    required this.isEdited,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  final String id;
  final String postId;
  final String body;
  final CommentAuthor author;
  final CommentCounts counts;
  final CommentViewerState viewerState;
  @JsonKey(fromJson: _repliesFromJson, toJson: _repliesToJson)
  final List<ReplyPreview> repliesPreview;
  final bool isEdited;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => _$CommentToJson(this);

  Comment copyWith({
    String? id,
    String? postId,
    String? body,
    CommentAuthor? author,
    CommentCounts? counts,
    CommentViewerState? viewerState,
    List<ReplyPreview>? repliesPreview,
    bool? isEdited,
    DateTime? createdAt,
  }) =>
      Comment(
        id: id ?? this.id,
        postId: postId ?? this.postId,
        body: body ?? this.body,
        author: author ?? this.author,
        counts: counts ?? this.counts,
        viewerState: viewerState ?? this.viewerState,
        repliesPreview: repliesPreview ?? this.repliesPreview,
        isEdited: isEdited ?? this.isEdited,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  List<Object?> get props => [
        id,
        postId,
        body,
        author,
        counts,
        viewerState,
        repliesPreview,
        isEdited,
        createdAt,
      ];
}
