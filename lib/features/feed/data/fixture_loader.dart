import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'models/feed_page.dart';

// Temporary seam: M6 replaces this with a real repository backed by Dio.
// Until then, the feed is driven entirely by the bundled fixture.
Future<FeedPage> loadFeedFixture() async {
  final String raw =
      await rootBundle.loadString('assets/fixtures/feed_response.json');
  final Map<String, dynamic> json = jsonDecode(raw) as Map<String, dynamic>;
  return FeedPage.fromJson(json);
}
