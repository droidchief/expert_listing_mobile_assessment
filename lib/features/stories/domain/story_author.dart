import 'package:equatable/equatable.dart';

class StoryAuthor extends Equatable {
  const StoryAuthor({
    required this.id,
    required this.username,
    required this.displayName,
    required this.avatarUrl,
    required this.isVerified,
    required this.isBusiness,
  });

  final String id;
  final String username;
  final String displayName;
  final String avatarUrl;
  final bool isVerified;
  final bool isBusiness;

  StoryAuthor copyWith({
    String? id,
    String? username,
    String? displayName,
    String? avatarUrl,
    bool? isVerified,
    bool? isBusiness,
  }) =>
      StoryAuthor(
        id: id ?? this.id,
        username: username ?? this.username,
        displayName: displayName ?? this.displayName,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        isVerified: isVerified ?? this.isVerified,
        isBusiness: isBusiness ?? this.isBusiness,
      );

  @override
  List<Object?> get props =>
      [id, username, displayName, avatarUrl, isVerified, isBusiness];
}
