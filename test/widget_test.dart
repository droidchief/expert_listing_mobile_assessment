import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:expert_listing_mobile_assessment/app.dart';

void main() {
  testWidgets('launches to the Feed tab with the wordmark and mail icon',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ExpertListingApp());
    await tester.pumpAndSettle();

    expect(find.text('Expert Listing'), findsOneWidget);
    expect(find.byIcon(Icons.mail_outline), findsOneWidget);
  });
}
