import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/common/widgets/custom_button.dart';
import 'package:flutter_amazon_clone/domain/auth/pages/auth_page.dart';
import 'package:flutter_amazon_clone/domain/auth/repositories/auth_repository.dart';
import 'package:flutter_amazon_clone/utils/provider_scope.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../mock_repositories/mock_auth_repository.dart';

void main() {
  testWidgets(
    'AuthPage UI Test',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final overrides = await providerScopeOverrides;
      final Widget testWidget = MaterialApp(
        home: ProviderScope(
          overrides: [
            ...overrides,
            authRepositoryProvider.overrideWithValue(
              MockAuthRepository(),
            ),
          ],
          child: AuthPage(),
        ),
      );

      await tester.pumpWidget(testWidget);

      // ジェネリクスでvalueプロパティに代入している値の型を指定しないとRadioは見つからない
      final radioFinder = find.byType(Radio<AuthStatus>);
      expect(radioFinder, findsNWidgets(2));

      // 2つ目のRadioボタンをタップ
      // Keyを指定しているとWidgetを見つけやすい
      await tester.tap(find.byKey(AuthPage.singInRadioKey));

      // pump()でページを更新しないとSign Inボタンは見つからない
      await tester.pump();

      // テキストフィールドを見つける
      final singInEmailTextFieldFinder = find.byKey(AuthPage.singInEmailTextFieldKey);
      final singInPasswordTextFieldFinder = find.byKey(AuthPage.singInPasswordTextFieldKey);

      // テキストフィールドを入力する
      await tester.enterText(singInEmailTextFieldFinder, 'test@gmail.com');
      await tester.testTextInput.receiveAction(TextInputAction.done);

      await tester.enterText(singInPasswordTextFieldFinder, 'test-password');
      await tester.testTextInput.receiveAction(TextInputAction.done);

      await tester.pumpAndSettle();

      // Sign-In のテキストフィールドに メールアドレスとパスワードが入力されている状態で、
      // Sign In ボタンをタップ
      await tester.tap(find.text('Sign In'));

      // No GoRouter found in context でテストが失敗する...
      // TODO(shimizu-saffle): GoRouter のテストの書き方を調べる

      // Sign Up
      await tester.tap(find.byKey(AuthPage.createAccountRadioKey));
      await tester.pump();

      // Sign Upボタンをタップ
      await tester.tap(find.byType(CustomButton).first);
    },
  );
}
