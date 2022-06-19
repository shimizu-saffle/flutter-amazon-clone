import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/features/auth/pages/auth_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'AuthPage UI Test',
    (WidgetTester tester) async {
      final Widget testWidget = MediaQuery(
        data: const MediaQueryData(),
        child: MaterialApp(
          home: AuthPage(),
        ),
      );

      await tester.pumpWidget(testWidget);

      // ラジオボタンを見つける
      final radioFinder = find.byType(Radio<Auth>);
      // ラジオボタンが2つあることを確認する
      expect(radioFinder, findsNWidgets(2));
    },
  );
}
