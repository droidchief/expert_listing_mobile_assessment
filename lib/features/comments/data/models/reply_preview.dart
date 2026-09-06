import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'reply_author.dart';

part 'reply_preview.g.dart';

@JsonSerializable()
class ReplyPreview extends Equatable {
  const ReplyPreview({
    required this.id,
    required this.body,
    required this.createdAt,
    required this.author,
  });

  factory ReplyPreview.fromJson(Map<String, dynamic> json) =>
      _$ReplyPreviewFromJson(json);

  final String id;
  final String body;
  // UTC — convert with .toLocal() at render time only.
  final DateTime createdAt;
  final ReplyAuthor author;

  Map<String, dynamic> toJson() => _$ReplyPreviewToJson(this);

  ReplyPreview copyWith({
    String? id,
    String? body,
    DateTime? createdAt,
    ReplyAuthor? author,
  }) =>
      ReplyPreview(
        id: id ?? this.id,
        body: body ?? this.body,
        createdAt: createdAt ?? this.createdAt,
        author: author ?? this.author,
      );

  @override
  List<Object?> get props => [id, body, createdAt, author];
}
