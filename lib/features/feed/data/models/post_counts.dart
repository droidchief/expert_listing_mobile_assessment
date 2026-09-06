import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_counts.g.dart';

@JsonSerializable()
class PostCounts extends Equatable {
  const PostCounts({
    required this.likes,
    required this.comments,
    required this.shares,
    required this.bookmarks,
    required this.views,
  });

  factory PostCounts.fromJson(Map<String, dynamic> json) =>
      _$PostCountsFromJson(json);

  final int likes;
  final int comments;
  final int shares;
  final int bookmarks;
  final int views;

  Map<String, dynamic> toJson() => _$PostCountsToJson(this);

  PostCounts copyWith({
    int? likes,
    int? comments,
    int? shares,
    int? bookmarks,
    int? views,
  }) =>
      PostCounts(
        likes: likes ?? this.likes,
        comments: comments ?? this.comments,
        shares: shares ?? this.shares,
        bookmarks: bookmarks ?? this.bookmarks,
        views: views ?? this.views,
      );

  @override
  List<Object?> get props => [likes, comments, shares, bookmarks, views];
}
