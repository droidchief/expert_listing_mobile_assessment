import 'package:flutter_test/flutter_test.dart';

import 'package:expert_listing_mobile_assessment/core/utils/relative_time.dart';

void main() {
  final DateTime now = DateTime.utc(2026, 3, 12, 12, 0, 0);

  String rel(Duration ago) => relativeTime(now.subtract(ago), now: now);

  group('relativeTime', () {
    test('under 60 seconds is Just Now', () {
      expect(rel(const Duration(seconds: 30)), 'Just Now');
      expect(rel(const Duration(seconds: 59)), 'Just Now');
    });

    test('boundary at exactly 60 seconds becomes minutes', () {
      expect(rel(const Duration(seconds: 60)), '1m');
    });

    test('minutes under an hour', () {
      expect(rel(const Duration(minutes: 5)), '5m');
      expect(rel(const Duration(minutes: 59)), '59m');
    });

    test('boundary at exactly 60 minutes becomes hours', () {
      expect(rel(const Duration(minutes: 60)), '1h');
    });

    test('hours under a day', () {
      expect(rel(const Duration(hours: 2)), '2h');
      expect(rel(const Duration(hours: 23)), '23h');
    });

    test('boundary at exactly 24 hours becomes days', () {
      expect(rel(const Duration(hours: 24)), '1d');
    });

    test('days under a week', () {
      expect(rel(const Duration(days: 3)), '3d');
      expect(rel(const Duration(days: 6)), '6d');
    });

    test('boundary at exactly 7 days becomes weeks', () {
      expect(rel(const Duration(days: 7)), '1w');
    });

    test('weeks under 5 weeks', () {
      expect(rel(const Duration(days: 14)), '2w');
      expect(rel(const Duration(days: 34)), '4w');
    });

    test('boundary at 35 days becomes a date', () {
      expect(rel(const Duration(days: 35)), '5 Feb');
    });

    test('older dates in the same year render as day and month', () {
      expect(rel(const Duration(days: 40)), '31 Jan');
    });

    test('a different calendar year appends the year', () {
      expect(
        relativeTime(DateTime.utc(2025, 12, 25), now: now),
        '25 Dec 2025',
      );
    });
  });
}
