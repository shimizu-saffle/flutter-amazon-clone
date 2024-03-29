import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/pages/auth_page.dart';
import 'package:flutter_amazon_clone/pages/home_page.dart';
import 'package:flutter_amazon_clone/repositories/auth_repository.dart';
import 'package:flutter_amazon_clone/utils/provider_scope.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mock/repositories/mock_auth_repository.dart';
import '../mock/router/mock_go_router.dart';
import '../mock/router/mock_go_router_provider.dart';

void main() {
  testWidgets(
    'メールアドレスとパスワードを入力して、Sign In ボタンを押すと context.go(HomePage.routePath) が呼ばれるはず',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final overrides = await providerScopeOverrides;
      final mockGoRouter = MockGoRouter();
      final Widget testWidget = MaterialApp(
        home: ProviderScope(
          overrides: [
            ...overrides,
            authRepositoryProvider.overrideWithValue(
              MockAuthRepository(),
            ),
          ],
          child: MockGoRouterProvider(
            goRouter: mockGoRouter,
            child: AuthPage(),
          ),
        ),
      );

      await tester.pumpWidget(testWidget);

      // 見つけたい Radio のジェネリクスまで書かないとRadioは見つからない
      final radioFinder = find.byType(Radio<AuthStatus>);
      expect(radioFinder, findsNWidgets(2));

      // 2つ目のRadioボタンをタップ
      // Key を指定していると Widget を見つけるのが容易になる
      await tester.tap(find.byKey(AuthPage.singInRadioKey));

      // pump() でページを更新しないと Sign In ボタンは見つからない
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

      // context.go(HomePage.routePath) が呼ばれることを確認する方法
      // verify(() => mockGoRouter.go(HomePage.routePath)).called(1);

      // calledLocations に HomePage.routePath が含まれていることを確認
      expect(mockGoRouter.calledLocations.contains(HomePage.routePath), true);
    },
  );
}
