import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'comment.dart';

part 'create_comment_result.g.dart';

@JsonSerializable(explicitToJson: true)
class CreateCommentResult extends Equatable {
  const CreateCommentResult({
    required this.comment,
    required this.postCommentCount,
  });

  factory CreateCommentResult.fromJson(Map<String, dynamic> json) =>
      _$CreateCommentResultFromJson(json);

  final Comment comment;
  final int postCommentCount;

  Map<String, dynamic> toJson() => _$CreateCommentResultToJson(this);

  CreateCommentResult copyWith({Comment? comment, int? postCommentCount}) =>
      CreateCommentResult(
        comment: comment ?? this.comment,
        postCommentCount: postCommentCount ?? this.postCommentCount,
      );

  @override
  List<Object?> get props => [comment, postCommentCount];
}
