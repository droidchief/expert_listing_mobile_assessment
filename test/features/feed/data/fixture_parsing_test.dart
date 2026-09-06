import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

import 'package:expert_listing_mobile_assessment/features/feed/data/models/feed_page.dart';

// M2's fixture_loader.dart was deleted in M4 (the feed now reads the live
// API, never the bundled JSON). This test loads the fixture directly to
// keep proving the M2 models still parse a real captured API response.
Future<FeedPage> _loadFixture() async {
  final raw =
      await rootBundle.loadString('assets/fixtures/feed_response.json');
  return FeedPage.fromJson(jsonDecode(raw) as Map<String, dynamic>);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('parses every post in the real feed fixture without throwing', () async {
    final feedPage = await _loadFixture();

    expect(feedPage.data, isNotEmpty);
    expect(feedPage.pagination.limit, greaterThan(0));

    for (final post in feedPage.data) {
      expect(post.id, isNotEmpty);
      expect(post.author.id, isNotEmpty);
    }
  });

  test('the five design posts are present with the expected shapes', () async {
    final feedPage = await _loadFixture();
    final byId = {for (final p in feedPage.data) p.id: p};

    const prefix = '20000000-0000-0000-0000-00000000000';

    final post1 = byId['${prefix}1']!;
    expect(post1.author.displayName, 'Felix Okon');
    expect(post1.showRoleBadge, isFalse);

    final post3 = byId['${prefix}3']!;
    expect(post3.author.displayName, 'Boyd From');
    expect(post3.showRoleBadge, isTrue);
    expect(post3.media, isNotEmpty);
    expect(post3.media.first.aspectRatio, isNotNull);

    final post5 = byId['${prefix}5']!;
    expect(post5.author.displayName, 'Felix Okon');
    expect(post5.showRoleBadge, isTrue);
    expect(post5.media.single.durationSeconds, 30);
  });
}
