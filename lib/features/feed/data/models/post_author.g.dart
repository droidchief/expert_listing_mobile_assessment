// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_author.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostAuthor _$PostAuthorFromJson(Map<String, dynamic> json) => PostAuthor(
  id: json['id'] as String,
  username: json['username'] as String,
  displayName: json['display_name'] as String,
  avatarUrl: json['avatar_url'] as String?,
  avatarBlurhash: json['avatar_blurhash'] as String?,
  role: $enumDecodeNullable(
    _$UserRoleEnumMap,
    json['role'],
    unknownValue: UserRole.unknown,
  ),
  roleLabel: json['role_label'] as String?,
  isVerified: json['is_verified'] as bool,
  isBusiness: json['is_business'] as bool,
);

Map<String, dynamic> _$PostAuthorToJson(PostAuthor instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'display_name': instance.displayName,
      'avatar_url': instance.avatarUrl,
      'avatar_blurhash': instance.avatarBlurhash,
      'role': _$UserRoleEnumMap[instance.role],
      'role_label': instance.roleLabel,
      'is_verified': instance.isVerified,
      'is_business': instance.isBusiness,
    };

const _$UserRoleEnumMap = {
  UserRole.individual: 'individual',
  UserRole.broker: 'broker',
  UserRole.agent: 'agent',
  UserRole.developer: 'developer',
  UserRole.landlord: 'landlord',
  UserRole.propertyManager: 'property_manager',
  UserRole.unknown: 'unknown',
};
