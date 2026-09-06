import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'comment_author_preview.dart';

part 'top_comment.g.dart';

@JsonSerializable()
class TopComment extends Equatable {
  const TopComment({
    required this.id,
    required this.body,
    required this.createdAt,
    required this.author,
  });

  factory TopComment.fromJson(Map<String, dynamic> json) =>
      _$TopCommentFromJson(json);

  final String id;
  final String body;
  final DateTime createdAt;
  final CommentAuthorPreview author;

  Map<String, dynamic> toJson() => _$TopCommentToJson(this);

  TopComment copyWith({
    String? id,
    String? body,
    DateTime? createdAt,
    CommentAuthorPreview? author,
  }) =>
      TopComment(
        id: id ?? this.id,
        body: body ?? this.body,
        createdAt: createdAt ?? this.createdAt,
        author: author ?? this.author,
      );

  @override
  List<Object?> get props => [id, body, createdAt, author];
}
