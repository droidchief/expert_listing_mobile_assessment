import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'viewer_state.g.dart';

@JsonSerializable()
class ViewerState extends Equatable {
  const ViewerState({required this.hasLiked, required this.isAuthor});

  factory ViewerState.fromJson(Map<String, dynamic> json) =>
      _$ViewerStateFromJson(json);

  final bool hasLiked;
  final bool isAuthor;

  Map<String, dynamic> toJson() => _$ViewerStateToJson(this);

  ViewerState copyWith({bool? hasLiked, bool? isAuthor}) => ViewerState(
        hasLiked: hasLiked ?? this.hasLiked,
        isAuthor: isAuthor ?? this.isAuthor,
      );

  @override
  List<Object?> get props => [hasLiked, isAuthor];
}
