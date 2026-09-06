import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'pagination.dart';
import 'post.dart';

part 'feed_page.g.dart';

List<Post> _postsFromJson(List<dynamic>? json) =>
    json?.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList() ??
    const [];

List<Map<String, dynamic>> _postsToJson(List<Post> posts) =>
    posts.map((e) => e.toJson()).toList();

@JsonSerializable()
class FeedPage extends Equatable {
  const FeedPage({this.data = const [], required this.pagination});

  factory FeedPage.fromJson(Map<String, dynamic> json) =>
      _$FeedPageFromJson(json);

  @JsonKey(fromJson: _postsFromJson, toJson: _postsToJson)
  final List<Post> data;
  final Pagination pagination;

  Map<String, dynamic> toJson() => _$FeedPageToJson(this);

  FeedPage copyWith({List<Post>? data, Pagination? pagination}) => FeedPage(
        data: data ?? this.data,
        pagination: pagination ?? this.pagination,
      );

  @override
  List<Object?> get props => [data, pagination];
}
