// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:raahi/main.dart';

void main() {
  testWidgets('Onboarding advances to the next section', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Plan scenic road trips'), findsOneWidget);
    expect(find.text('Navigate with confidence'), findsNothing);

    await tester.tap(find.text('Next'));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Navigate with confidence'), findsOneWidget);
  });
}
