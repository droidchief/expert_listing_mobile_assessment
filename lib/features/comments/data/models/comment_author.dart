import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_author.g.dart';

@JsonSerializable()
class CommentAuthor extends Equatable {
  const CommentAuthor({
    required this.id,
    required this.username,
    required this.displayName,
    this.avatarUrl,
    this.role,
    this.roleLabel,
    required this.isVerified,
  });

  factory CommentAuthor.fromJson(Map<String, dynamic> json) =>
      _$CommentAuthorFromJson(json);

  final String id;
  final String username;
  final String displayName;
  final String? avatarUrl;
  final String? role;
  final String? roleLabel;
  final bool isVerified;

  Map<String, dynamic> toJson() => _$CommentAuthorToJson(this);

  CommentAuthor copyWith({
    String? id,
    String? username,
    String? displayName,
    String? avatarUrl,
    String? role,
    String? roleLabel,
    bool? isVerified,
  }) =>
      CommentAuthor(
        id: id ?? this.id,
        username: username ?? this.username,
        displayName: displayName ?? this.displayName,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        role: role ?? this.role,
        roleLabel: roleLabel ?? this.roleLabel,
        isVerified: isVerified ?? this.isVerified,
      );

  @override
  List<Object?> get props =>
      [id, username, displayName, avatarUrl, role, roleLabel, isVerified];
}
