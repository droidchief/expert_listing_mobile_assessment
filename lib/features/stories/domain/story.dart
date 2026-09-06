import 'package:equatable/equatable.dart';

import '../story_constants.dart';

class Story extends Equatable {
  const Story({
    required this.id,
    required this.imageUrl,
    required this.createdAt,
    this.duration = kStoryDuration,
    this.isSeen = false,
  });

  final String id;
  final String imageUrl;
  // UTC.
  final DateTime createdAt;
  final Duration duration;
  final bool isSeen;

  Story copyWith({
    String? id,
    String? imageUrl,
    DateTime? createdAt,
    Duration? duration,
    bool? isSeen,
  }) =>
      Story(
        id: id ?? this.id,
        imageUrl: imageUrl ?? this.imageUrl,
        createdAt: createdAt ?? this.createdAt,
        duration: duration ?? this.duration,
        isSeen: isSeen ?? this.isSeen,
      );

  @override
  List<Object?> get props => [id, imageUrl, createdAt, duration, isSeen];
}
