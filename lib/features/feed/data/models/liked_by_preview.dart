import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'liked_by_user.dart';

part 'liked_by_preview.g.dart';

List<LikedByUser> _usersFromJson(List<dynamic>? json) =>
    json?.map((e) => LikedByUser.fromJson(e as Map<String, dynamic>)).toList() ??
    const [];

List<Map<String, dynamic>> _usersToJson(List<LikedByUser> users) =>
    users.map((e) => e.toJson()).toList();

@JsonSerializable()
class LikedByPreview extends Equatable {
  const LikedByPreview({required this.total, this.users = const []});

  factory LikedByPreview.fromJson(Map<String, dynamic> json) =>
      _$LikedByPreviewFromJson(json);

  final int total;
  @JsonKey(fromJson: _usersFromJson, toJson: _usersToJson)
  final List<LikedByUser> users;

  Map<String, dynamic> toJson() => _$LikedByPreviewToJson(this);

  LikedByPreview copyWith({int? total, List<LikedByUser>? users}) =>
      LikedByPreview(
        total: total ?? this.total,
        users: users ?? this.users,
      );

  @override
  List<Object?> get props => [total, users];
}
