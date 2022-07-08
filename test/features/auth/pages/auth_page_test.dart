import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/common/widgets/custom_button.dart';
import 'package:flutter_amazon_clone/domain/auth/pages/auth_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'AuthPage UI Test',
    (WidgetTester tester) async {
      final Widget testWidget = MaterialApp(
        home: AuthPage(),
      );

      await tester.pumpWidget(testWidget);

      // ジェネリクスでvalueプロパティに代入している値の型を指定しないとRadioは見つからない
      final radioFinder = find.byType(Radio<AuthStatus>);
      expect(radioFinder, findsNWidgets(2));
      // 2つ目のRadioボタンをタップ
      // Keyを指定しているとWidgetを見つけやすい
      await tester.tap(find.byKey(const Key('auth_page_radio_button_2')));
      // pump()でページを更新しないとSign Inボタンは見つからない
      await tester.pump();
      await tester.tap(find.text('Sign In'));

      await tester.tap(find.byKey(const Key('auth_page_radio_button_1')));
      await tester.pump();
      // Sign Upボタンをタップ
      await tester.tap(find.byType(CustomButton).first);
    },
  );
}
