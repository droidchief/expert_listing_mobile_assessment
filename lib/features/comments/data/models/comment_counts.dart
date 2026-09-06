import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_counts.g.dart';

/// `likes` is always 0 today — comment likes are out of scope, so nothing
/// renders it. Still parsed so a future non-zero value doesn't throw.
@JsonSerializable()
class CommentCounts extends Equatable {
  const CommentCounts({required this.likes, required this.replies});

  factory CommentCounts.fromJson(Map<String, dynamic> json) =>
      _$CommentCountsFromJson(json);

  final int likes;
  final int replies;

  Map<String, dynamic> toJson() => _$CommentCountsToJson(this);

  CommentCounts copyWith({int? likes, int? replies}) => CommentCounts(
        likes: likes ?? this.likes,
        replies: replies ?? this.replies,
      );

  @override
  List<Object?> get props => [likes, replies];
}
