import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_author_preview.g.dart';

@JsonSerializable()
class CommentAuthorPreview extends Equatable {
  const CommentAuthorPreview({
    required this.username,
    required this.displayName,
    this.avatarUrl,
  });

  factory CommentAuthorPreview.fromJson(Map<String, dynamic> json) =>
      _$CommentAuthorPreviewFromJson(json);

  final String username;
  final String displayName;
  final String? avatarUrl;

  Map<String, dynamic> toJson() => _$CommentAuthorPreviewToJson(this);

  CommentAuthorPreview copyWith({
    String? username,
    String? displayName,
    String? avatarUrl,
  }) =>
      CommentAuthorPreview(
        username: username ?? this.username,
        displayName: displayName ?? this.displayName,
        avatarUrl: avatarUrl ?? this.avatarUrl,
      );

  @override
  List<Object?> get props => [username, displayName, avatarUrl];
}
