import 'package:expenz/Screens/onboard_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'onboarding next button does not crash when page value is null',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardScreens(),
        ),
      );

      expect(find.text('Next'), findsOneWidget);

      await tester.tap(find.text('Next'));
      await tester.pump();

      expect(find.text('Next'), findsOneWidget);
    },
  );
}
