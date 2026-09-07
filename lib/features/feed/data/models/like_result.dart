import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'like_result.g.dart';

@JsonSerializable()
class LikeResult extends Equatable {
  const LikeResult({
    required this.postId,
    required this.hasLiked,
    required this.likeCount,
  });

  factory LikeResult.fromJson(Map<String, dynamic> json) =>
      _$LikeResultFromJson(json);

  final String postId;
  final bool hasLiked;
  final int likeCount;

  Map<String, dynamic> toJson() => _$LikeResultToJson(this);

  LikeResult copyWith({String? postId, bool? hasLiked, int? likeCount}) =>
      LikeResult(
        postId: postId ?? this.postId,
        hasLiked: hasLiked ?? this.hasLiked,
        likeCount: likeCount ?? this.likeCount,
      );

  @override
  List<Object?> get props => [postId, hasLiked, likeCount];
}
