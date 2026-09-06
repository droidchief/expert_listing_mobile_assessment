import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/enums.dart';

part 'post_author.g.dart';

@JsonSerializable()
class PostAuthor extends Equatable {
  const PostAuthor({
    required this.id,
    required this.username,
    required this.displayName,
    this.avatarUrl,
    this.avatarBlurhash,
    this.role,
    this.roleLabel,
    required this.isVerified,
    required this.isBusiness,
  });

  factory PostAuthor.fromJson(Map<String, dynamic> json) =>
      _$PostAuthorFromJson(json);

  final String id;
  final String username;
  final String displayName;
  final String? avatarUrl;
  final String? avatarBlurhash;
  @JsonKey(unknownEnumValue: UserRole.unknown)
  final UserRole? role;
  final String? roleLabel;
  final bool isVerified;
  final bool isBusiness;

  Map<String, dynamic> toJson() => _$PostAuthorToJson(this);

  PostAuthor copyWith({
    String? id,
    String? username,
    String? displayName,
    String? avatarUrl,
    String? avatarBlurhash,
    UserRole? role,
    String? roleLabel,
    bool? isVerified,
    bool? isBusiness,
  }) =>
      PostAuthor(
        id: id ?? this.id,
        username: username ?? this.username,
        displayName: displayName ?? this.displayName,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        avatarBlurhash: avatarBlurhash ?? this.avatarBlurhash,
        role: role ?? this.role,
        roleLabel: roleLabel ?? this.roleLabel,
        isVerified: isVerified ?? this.isVerified,
        isBusiness: isBusiness ?? this.isBusiness,
      );

  @override
  List<Object?> get props => [
        id,
        username,
        displayName,
        avatarUrl,
        avatarBlurhash,
        role,
        roleLabel,
        isVerified,
        isBusiness,
      ];
}
