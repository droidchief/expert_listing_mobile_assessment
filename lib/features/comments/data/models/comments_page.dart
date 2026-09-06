import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../feed/data/models/pagination.dart';
import 'comment.dart';

part 'comments_page.g.dart';

List<Comment> _commentsFromJson(List<dynamic>? json) =>
    json?.map((e) => Comment.fromJson(e as Map<String, dynamic>)).toList() ??
    const [];

List<Map<String, dynamic>> _commentsToJson(List<Comment> comments) =>
    comments.map((e) => e.toJson()).toList();

@JsonSerializable()
class CommentsPage extends Equatable {
  const CommentsPage({this.data = const [], required this.pagination});

  factory CommentsPage.fromJson(Map<String, dynamic> json) =>
      _$CommentsPageFromJson(json);

  @JsonKey(fromJson: _commentsFromJson, toJson: _commentsToJson)
  final List<Comment> data;
  final Pagination pagination;

  Map<String, dynamic> toJson() => _$CommentsPageToJson(this);

  CommentsPage copyWith({List<Comment>? data, Pagination? pagination}) =>
      CommentsPage(
        data: data ?? this.data,
        pagination: pagination ?? this.pagination,
      );

  @override
  List<Object?> get props => [data, pagination];
}
