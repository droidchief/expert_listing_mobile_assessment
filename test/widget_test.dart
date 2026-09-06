import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:expert_listing_mobile_assessment/app.dart';

void main() {
  testWidgets('launches to the Feed tab with the wordmark and app bar actions',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ExpertListingApp());
    await tester.pumpAndSettle();

    expect(find.byType(AppBar), findsOneWidget);
    // Wordmark + envelope + plus actions are all SVG assets now.
    expect(find.byType(SvgPicture), findsNWidgets(3));
    expect(find.text('Feed'), findsOneWidget);
  });
}
