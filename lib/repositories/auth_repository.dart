import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/response_result/response_result.dart';
import '../models/user/user.dart';
import '../services/dio_provider.dart';
import '../services/shared_preferences_provider.dart';

final authRepositoryProvider = Provider<AbstractAuthRepository>(
  (ref) => AuthRepository(ref.read),
);

abstract class AbstractAuthRepository {
  Future<ResponseResult<User?>> signUpUser({
    required User user,
  });

  Future<ResponseResult<User?>> signInUser({
    required String email,
    required String password,
  });

  Future<ResponseResult<User?>> getUserData();
}

class AuthRepository implements AbstractAuthRepository {
  AuthRepository(this._read);
  static const signupPath = '/api/signup';
  static const signinPath = '/api/signin';
  static const tokenIsValidPath = '/tokenIsValid';
  static const userInformationPath = '/';

  final Reader _read;

  @override
  Future<ResponseResult<User?>> signUpUser({
    required User user,
  }) async {
    try {
      final response = await _read(dioProvider).post<Map<String, dynamic>>(
        AuthRepository.signupPath,
        data: user.toJson(),
      );
      return ResponseResult.success(
        responseData: User.fromJson(response.data!),
      );
    } on DioError catch (e) {
      return ResponseResult.failure(message: e.message);
    } on Exception catch (e) {
      return ResponseResult.error(e);
    }
  }

  @override
  Future<ResponseResult<User?>> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _read(dioProvider).post<Map<String, dynamic>>(
        AuthRepository.signinPath,
        data: {
          'email': email,
          'password': password,
        },
      );
      final user = User.fromJson(response.data!);
      return ResponseResult.success(responseData: user);
    } on DioError catch (e) {
      return ResponseResult.failure(message: e.message);
    } on Exception catch (e) {
      return ResponseResult.error(e);
    }
  }

  @override
  Future<ResponseResult<User?>> getUserData() async {
    try {
      final preference = _read(sharedPreferencesProvider);
      final token = preference.getString('x-auth-token');

      const user = User(name: '', email: '', password: '');

      if (token == null) {
        await preference.setString('x-auth-token', '');
        return const ResponseResult.success(responseData: user);
      }
      if (token.isEmpty) {
        return const ResponseResult.success(responseData: user);
      }

      final tokenResponse = await _read(dioProvider).post<bool>(
        AuthRepository.tokenIsValidPath,
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        ),
      );

      if (tokenResponse.data == true) {
        final userResponse = await _read(dioProvider).get<Map<String, dynamic>>(
          AuthRepository.userInformationPath,
          options: Options(
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token
            },
          ),
        );
        return ResponseResult.success(
          responseData: User.fromJson(userResponse.data!),
        );
      } else {
        await preference.setString('x-auth-token', '');
        return const ResponseResult.success(responseData: user);
      }
    } on DioError catch (e) {
      return ResponseResult.failure(message: e.message);
    } on Exception catch (e) {
      return ResponseResult.error(e);
    }
  }
}
