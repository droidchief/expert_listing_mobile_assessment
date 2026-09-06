import 'package:flutter_test/flutter_test.dart';

import 'package:expert_listing_mobile_assessment/features/stories/domain/story.dart';
import 'package:expert_listing_mobile_assessment/features/stories/domain/story_author.dart';
import 'package:expert_listing_mobile_assessment/features/stories/domain/story_group.dart';
import 'package:expert_listing_mobile_assessment/features/stories/presentation/cubit/stories_cubit.dart';
import 'package:expert_listing_mobile_assessment/features/stories/presentation/cubit/stories_state.dart';

StoryAuthor _author(String id) => StoryAuthor(
      id: id,
      username: id,
      displayName: id,
      avatarUrl: 'https://example.com/$id.jpg',
      isVerified: false,
      isBusiness: false,
    );

Story _story(String id, {required DateTime createdAt, bool isSeen = false}) =>
    Story(id: id, imageUrl: 'https://example.com/$id.jpg', createdAt: createdAt, isSeen: isSeen);

void main() {
  group('StoryGroup.firstUnseenIndex', () {
    test('is 0 when every story is unseen', () {
      final group = StoryGroup(
        author: _author('a'),
        stories: [
          _story('s1', createdAt: DateTime(2026, 1, 1)),
          _story('s2', createdAt: DateTime(2026, 1, 2)),
        ],
      );
      expect(group.firstUnseenIndex, 0);
    });

    test('skips leading seen stories', () {
      final group = StoryGroup(
        author: _author('a'),
        stories: [
          _story('s1', createdAt: DateTime(2026, 1, 1), isSeen: true),
          _story('s2', createdAt: DateTime(2026, 1, 2)),
          _story('s3', createdAt: DateTime(2026, 1, 3)),
        ],
      );
      expect(group.firstUnseenIndex, 1);
    });

    test('is 0 when every story is already seen', () {
      final group = StoryGroup(
        author: _author('a'),
        stories: [
          _story('s1', createdAt: DateTime(2026, 1, 1), isSeen: true),
          _story('s2', createdAt: DateTime(2026, 1, 2), isSeen: true),
        ],
      );
      expect(group.firstUnseenIndex, 0);
    });
  });

  group('StoriesCubit', () {
    test('load() sorts unseen groups before seen, newest first within each band', () {
      final cubit = StoriesCubit();
      cubit.load();

      final groups = cubit.state.groups;
      expect(cubit.state.status, StoriesStatus.success);
      expect(groups, isNotEmpty);

      final firstSeenIndex = groups.indexWhere((g) => !g.hasUnseen);
      // Every group before the first seen one must have unseen stories.
      for (var i = 0; i < firstSeenIndex; i++) {
        expect(groups[i].hasUnseen, isTrue);
      }
      // Every group from the first seen one onward must be fully seen.
      for (var i = firstSeenIndex; i < groups.length; i++) {
        expect(groups[i].hasUnseen, isFalse);
      }

      cubit.close();
    });

    test('markSeen() does not change group order', () {
      final cubit = StoriesCubit();
      cubit.load();
      final orderBefore = cubit.state.groups.map((g) => g.author.id).toList();

      final firstGroup = cubit.state.groups.first;
      cubit.markSeen(firstGroup.author.id, firstGroup.stories.first.id);

      final orderAfter = cubit.state.groups.map((g) => g.author.id).toList();
      expect(orderAfter, orderBefore);

      cubit.close();
    });

    test('markSeen() flips only the targeted story', () {
      final cubit = StoriesCubit();
      cubit.load();
      final target = cubit.state.groups.first;
      final targetStoryId = target.stories.first.id;

      cubit.markSeen(target.author.id, targetStoryId);

      final updated =
          cubit.state.groups.firstWhere((g) => g.author.id == target.author.id);
      expect(updated.stories.first.isSeen, isTrue);
      if (updated.stories.length > 1) {
        expect(updated.stories[1].isSeen, target.stories[1].isSeen);
      }

      cubit.close();
    });
  });
}
