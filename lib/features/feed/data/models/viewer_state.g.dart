// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'viewer_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ViewerState _$ViewerStateFromJson(Map<String, dynamic> json) => ViewerState(
  hasLiked: json['has_liked'] as bool,
  isAuthor: json['is_author'] as bool,
);

Map<String, dynamic> _$ViewerStateToJson(ViewerState instance) =>
    <String, dynamic>{
      'has_liked': instance.hasLiked,
      'is_author': instance.isAuthor,
    };
