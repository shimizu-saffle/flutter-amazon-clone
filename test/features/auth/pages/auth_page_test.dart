import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/features/auth/pages/auth_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'Test to find AuthPage title',
    (WidgetTester tester) async {
      final Widget testWidget = MediaQuery(
        data: const MediaQueryData(),
        child: MaterialApp(
          home: AuthPage(),
        ),
      );
      await tester.pumpWidget(testWidget);
      final pageTitleFinder = find.text('Welcome');
      expect(pageTitleFinder, findsOneWidget);
    },
  );
}
