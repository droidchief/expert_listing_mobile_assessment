import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_viewer_state.g.dart';

@JsonSerializable()
class CommentViewerState extends Equatable {
  const CommentViewerState({required this.isAuthor});

  factory CommentViewerState.fromJson(Map<String, dynamic> json) =>
      _$CommentViewerStateFromJson(json);

  final bool isAuthor;

  Map<String, dynamic> toJson() => _$CommentViewerStateToJson(this);

  CommentViewerState copyWith({bool? isAuthor}) =>
      CommentViewerState(isAuthor: isAuthor ?? this.isAuthor);

  @override
  List<Object?> get props => [isAuthor];
}
