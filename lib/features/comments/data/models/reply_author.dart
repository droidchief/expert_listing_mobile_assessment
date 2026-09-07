import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reply_author.g.dart';

@JsonSerializable()
class ReplyAuthor extends Equatable {
  const ReplyAuthor({
    required this.username,
    required this.displayName,
    this.avatarUrl,
  });

  factory ReplyAuthor.fromJson(Map<String, dynamic> json) =>
      _$ReplyAuthorFromJson(json);

  final String username;
  final String displayName;
  final String? avatarUrl;

  Map<String, dynamic> toJson() => _$ReplyAuthorToJson(this);

  ReplyAuthor copyWith({
    String? username,
    String? displayName,
    String? avatarUrl,
  }) =>
      ReplyAuthor(
        username: username ?? this.username,
        displayName: displayName ?? this.displayName,
        avatarUrl: avatarUrl ?? this.avatarUrl,
      );

  @override
  List<Object?> get props => [username, displayName, avatarUrl];
}
