import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pagination.g.dart';

@JsonSerializable()
class Pagination extends Equatable {
  const Pagination({
    this.nextCursor,
    required this.hasMore,
    required this.limit,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);

  final String? nextCursor;
  final bool hasMore;
  final int limit;

  Map<String, dynamic> toJson() => _$PaginationToJson(this);

  Pagination copyWith({String? nextCursor, bool? hasMore, int? limit}) =>
      Pagination(
        nextCursor: nextCursor ?? this.nextCursor,
        hasMore: hasMore ?? this.hasMore,
        limit: limit ?? this.limit,
      );

  @override
  List<Object?> get props => [nextCursor, hasMore, limit];
}
