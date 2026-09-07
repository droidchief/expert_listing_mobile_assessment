import '../domain/story.dart';
import '../domain/story_author.dart';
import '../domain/story_group.dart';

// Mock data only — no networking. 
DateTime _ago(Duration duration) => DateTime.now().toUtc().subtract(duration);

StoryAuthor _author(
  String username,
  String displayName, {
  bool isVerified = false,
  bool isBusiness = false,
}) =>
    StoryAuthor(
      id: 'author-$username',
      username: username,
      displayName: displayName,
      avatarUrl: 'https://i.pravatar.cc/150?u=$username',
      isVerified: isVerified,
      isBusiness: isBusiness,
    );

Story _story(
  String username,
  int index,
  Duration age, {
  bool isSeen = false,
}) =>
    Story(
      id: 'story-$username-$index',
      imageUrl: 'https://picsum.photos/seed/$username-story-$index/1080/1920',
      createdAt: _ago(age),
      isSeen: isSeen,
    );


List<StoryGroup> mockStoryGroups() => [
      StoryGroup(
        author: _author(
          'ramosrealty',
          'Ramos Realty',
          isVerified: true,
        ),
        stories: [
          _story('ramosrealty', 1, const Duration(minutes: 30)),
          _story('ramosrealty', 2, const Duration(hours: 1)),
          _story('ramosrealty', 3, const Duration(hours: 2)),
        ],
      ),
      StoryGroup(
        author: _author('jordan', 'Jordan'),
        stories: [
          _story('jordan', 1, const Duration(hours: 2, minutes: 30)),
          _story('jordan', 2, const Duration(hours: 3)),
        ],
      ),
      StoryGroup(
        author: _author('taylor', 'Taylor'),
        stories: [
          _story('taylor', 1, const Duration(hours: 4)),
        ],
      ),
      StoryGroup(
        author: _author('jamie', 'Jamie'),
        stories: [
          _story('jamie', 1, const Duration(hours: 5)),
          _story('jamie', 2, const Duration(hours: 6)),
          _story('jamie', 3, const Duration(hours: 7)),
          _story('jamie', 4, const Duration(hours: 8)),
        ],
      ),
      StoryGroup(
        author: _author('boyd.from', 'Boyd From', isBusiness: false),
        stories: [
          _story('boyd.from', 1, const Duration(hours: 9)),
          _story('boyd.from', 2, const Duration(hours: 10)),
        ],
      ),
      StoryGroup(
        author: _author('felix.okon', 'Felix Okon'),
        stories: [
          _story('felix.okon', 1, const Duration(hours: 11), isSeen: true),
          _story('felix.okon', 2, const Duration(hours: 12)),
          _story('felix.okon', 3, const Duration(hours: 13)),
        ],
      ),
      StoryGroup(
        author: _author('maurice.u', 'Maurice U'),
        stories: [
          _story('maurice.u', 1, const Duration(hours: 14), isSeen: true),
        ],
      ),
      StoryGroup(
        author: _author('tunde_b', 'Tunde B'),
        stories: [
          _story('tunde_b', 1, const Duration(hours: 16), isSeen: true),
          _story('tunde_b', 2, const Duration(hours: 17), isSeen: true),
        ],
      ),
      StoryGroup(
        author: _author('adaeze.n', 'Adaeze N'),
        stories: [
          _story('adaeze.n', 1, const Duration(hours: 19)),
          _story('adaeze.n', 2, const Duration(hours: 20)),
        ],
      ),
    ];
