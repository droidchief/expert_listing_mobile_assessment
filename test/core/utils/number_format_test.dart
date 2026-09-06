import 'package:flutter_test/flutter_test.dart';

import 'package:expert_listing_mobile_assessment/core/utils/number_format.dart';

void main() {
  group('formatCount', () {
    test('zero is hidden', () {
      expect(formatCount(0), '');
    });

    test('single digit', () {
      expect(formatCount(1), '1');
    });

    test('hundreds', () {
      expect(formatCount(700), '700');
    });

    test('boundary at 999 stays unabbreviated', () {
      expect(formatCount(999), '999');
    });

    test('boundary at 1000 abbreviates', () {
      expect(formatCount(1000), '1K');
    });

    test('thousands round to one decimal', () {
      expect(formatCount(1043), '1K');
      expect(formatCount(1500), '1.5K');
      expect(formatCount(12400), '12.4K');
    });

    test('millions', () {
      expect(formatCount(1000000), '1M');
    });
  });

  group('formatViewCount', () {
    test('hides counts under 100', () {
      expect(formatViewCount(0), '');
      expect(formatViewCount(99), '');
    });

    test('shows counts at and above 100', () {
      expect(formatViewCount(100), '100');
      expect(formatViewCount(700), '700');
      expect(formatViewCount(1043), '1K');
    });
  });
}
