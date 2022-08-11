import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_amazon_clone/domain/auth/repositories/auth_repository.dart';
import 'package:flutter_amazon_clone/models/response_result/response_result.dart';
import 'package:flutter_amazon_clone/models/user/user.dart';
import 'package:flutter_amazon_clone/providers/dio_provider.dart';
import 'package:flutter_amazon_clone/providers/shared_preferences_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

          response.when(
            success: (responseData, message, success) {
              expect(responseData?.email, user.email);
            },
            failure: (message) {
              debugPrint(message);
              throw Exception('signInUser() failure');
            },
            error: (e) {
              debugPrint(e.toString());
              throw Exception('signInUser() error');
            },
          );
        },
      );

      // signInUser() 失敗時のテスト
      test(
        'user credentials が正しくない場合 の ResponseResult は　failure のはず',
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
          expect(response, const ResponseResult<User?>.failure(message: ''));
        },
      );

      // signUpUser() 成功時のテスト
      test(
        'signUpUser success',
        () async {
          final user = User.fromJson(mockUserCredentials);
          dioAdapter.onPost(
            AuthRepository.signupPath,
            (server) => server.reply(200, mockUserCredentials),
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

      // getUserData() 成功時のテスト
      test(
        'getUserData success',
        () async {
          const mockAuthToken = 'mock-auth-token';
          SharedPreferences.setMockInitialValues({
            'x-auth-token': mockAuthToken,
          });
          final mockPreference = await SharedPreferences.getInstance();
          container = ProviderContainer(
            overrides: [
              dioProvider.overrideWithValue(dio),
              sharedPreferencesProvider.overrideWithValue(mockPreference),
            ],
          );
          dioAdapter
            ..onPost(
              AuthRepository.tokenIsValidPath,
              (server) => server.reply(200, true),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': mockAuthToken,
              },
            )
            ..onPost(
              AuthRepository.userInformationPath,
              (server) => server.reply(200, mockUserCredentials),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': mockAuthToken,
              },
            );
          final responseResult = await container.read(authRepositoryProvider).getUserData();
          responseResult.when(
            success: (responseData, message, success) {
              expect(responseData?.email, mockUserCredentials['email']);
            },
            failure: (message) {
              debugPrint(message);
              throw Exception('getUserData() failure');
            },
            error: (e) {
              debugPrint(e.toString());
              throw Exception('getUserData() error');
            },
          );
        },
      );

      // getUserData() 失敗時のテスト
      test(
        'getUserData failure',
        () async {
          const mockAuthToken = 'mock-auth-token';
          SharedPreferences.setMockInitialValues({
            'x-auth-token': mockAuthToken,
          });
          final mockPreference = await SharedPreferences.getInstance();
          container = ProviderContainer(
            overrides: [
              dioProvider.overrideWithValue(dio),
              sharedPreferencesProvider.overrideWithValue(mockPreference),
            ],
          );
          dioAdapter
            ..onPost(
              AuthRepository.tokenIsValidPath,
              (server) => server.reply(200, true),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': mockAuthToken,
              },
            )
            ..onPost(
              AuthRepository.userInformationPath,
              (server) => server.throws(
                401,
                DioError(
                  requestOptions: RequestOptions(
                    path: AuthRepository.userInformationPath,
                  ),
                ),
              ),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': mockAuthToken,
              },
            );
          final response = await container.read(authRepositoryProvider).getUserData();
          expect(response, null);
        },
      );
    },
  );
}
