import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/domain/auth/repositories/auth_repository.dart';
import 'package:flutter_amazon_clone/models/user/user.dart';
import 'package:flutter_amazon_clone/providers/dio_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProviderContainer container;
  late DioAdapter dioAdapter;

  setUpAll(() async {
    final dio = Dio();
    dioAdapter = DioAdapter(dio: dio);
    container = ProviderContainer();
    container.read(dioProvider).httpClientAdapter = dioAdapter;
  });

  group('AuthRepository test', () {
    const mockUserData = <String, dynamic>{
      'name': 'mock name',
      'email': 'test@example.com',
      'password': 'password',
    };

    // signInUser() の引数に BuildContext が必要なので、testWidgets() を呼び出す
    testWidgets('signInUser() の返り値は Future<User?>型であるはず', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          Builder(
            builder: (BuildContext context) {
              // final path = '$baseUrl/api/signin';
              final user = User.fromJson(mockUserData);

              // dioAdapter.onPost(path, (request) {
              //   request.reply(200, mockUserData);
              // });

              final response = container.read(authRepositoryProvider).signInUser(
                    email: user.email,
                    password: user.password,
                  );
              expect(response, isA<Future<User?>>());

              // builder 関数は Widget を返さなければならない
              return const Placeholder();
            },
          ),
        );
      });
    });
  });
}
