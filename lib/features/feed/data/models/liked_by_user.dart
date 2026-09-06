import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'liked_by_user.g.dart';

@JsonSerializable()
class LikedByUser extends Equatable {
  const LikedByUser({required this.username, this.avatarUrl});

  factory LikedByUser.fromJson(Map<String, dynamic> json) =>
      _$LikedByUserFromJson(json);

  final String username;
  final String? avatarUrl;

  Map<String, dynamic> toJson() => _$LikedByUserToJson(this);

  LikedByUser copyWith({String? username, String? avatarUrl}) => LikedByUser(
        username: username ?? this.username,
        avatarUrl: avatarUrl ?? this.avatarUrl,
      );

  @override
  List<Object?> get props => [username, avatarUrl];
}
