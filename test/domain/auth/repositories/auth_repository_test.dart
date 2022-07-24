import 'package:dio/dio.dart';
import 'package:flutter_amazon_clone/domain/auth/repositories/auth_repository.dart';
import 'package:flutter_amazon_clone/models/user/user.dart';
import 'package:flutter_amazon_clone/providers/dio_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Dio dio;
  late DioAdapter dioAdapter;
  late ProviderContainer container;

  group(
    'AuthRepository test',
    () {
      const testBaseUrl = 'https://test.com';
      const mockUserCredentials = <String, dynamic>{
        'name': 'mock name',
        'email': 'test@example.com',
        'password': 'password',
      };

      setUp(
        () {
          dio = Dio(
            BaseOptions(baseUrl: testBaseUrl),
          );
          dioAdapter = DioAdapter(
            dio: dio,
            matcher: const UrlRequestMatcher(),
          );
          container = ProviderContainer(
            overrides: [
              dioProvider.overrideWithValue(dio),
            ],
          );
          container.read(dioProvider).httpClientAdapter = dioAdapter;
        },
      );

      // signInUser() 成功時のテスト
      test(
        'signInUser メソッドのリクエストの email と レスポンスの email は一致するはず',
        () async {
          final user = User.fromJson(mockUserCredentials);

          dioAdapter.onPost(
            AuthRepository.signinPath,
            (server) => server.reply(200, user),
            data: {
              'email': 'test@example.com',
              'password': 'password',
            },
          );

          final response = await container.read(authRepositoryProvider).signInUser(
                email: user.email,
                password: user.password,
              );

          expect(response?.email, user.email);
        },
      );

      // signInUser() 失敗時のテスト
      test(
        'user credentials が正しくない場合は null が 返されるはず',
        () async {
          dioAdapter.onPost(
            AuthRepository.signinPath,
            (server) => server.throws(
              401,
              DioError(
                requestOptions: RequestOptions(
                  path: '/api/signin',
                ),
              ),
            ),
          );

          final response = await container.read(authRepositoryProvider).signInUser(
                email: 'hoge',
                password: 'fuga',
              );

          expect(response, null);
        },
      );

      // signUpUser() 成功時のテスト
      test(
        'signUpUser success',
        () async {
          final user = User.fromJson(mockUserCredentials);
          dioAdapter.onPost(
            AuthRepository.signupPath,
            (server) => server.reply(200, null),
            data: user.toJson(),
          );
          await expectLater(
            container.read(authRepositoryProvider).signUpUser(user: user),
            completes,
          );
        },
      );

      // signUpUser() 失敗時のテスト
      test(
        'signUpUser failure',
        () async {
          final user = User.fromJson(mockUserCredentials);
          dioAdapter.onPost(
            AuthRepository.signupPath,
            (server) => server.throws(
              401,
              DioError(
                requestOptions: RequestOptions(
                  path: AuthRepository.signupPath,
                ),
              ),
            ),
          );
          await expectLater(
            container.read(authRepositoryProvider).signUpUser(user: user),
            completes,
          );
        },
      );
    },
  );
}
