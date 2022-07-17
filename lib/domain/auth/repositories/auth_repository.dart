import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../models/user/user.dart';
import '../../../providers/dio_provider.dart';
import '../../../providers/shared_preferences_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository(ref.read));

class AuthRepository {
  AuthRepository(this._read);

  final Reader _read;

  Future<void> signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final user = User(
        email: email,
        password: password,
        name: name,
      );
      final response = await _read(dioProvider).post<Map<String, dynamic>>(
        '$baseUrl/api/signup',
        data: user.toJson(),
        options: Options(
          headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        ),
      );
      dioErrorHandling(
        response: response,
        context: context,
        onSuccess: () => showSnackBar(
          context,
          'Account created! Login with the same credentials!',
        ),
      );
    } on DioError catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<User?> signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _read(dioProvider).post<Map<String, dynamic>>(
        '$baseUrl/api/signin',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        ),
      );
      dioErrorHandling(
        response: response,
        context: context,
      );
      return User.fromJson(response.data!);
    } on DioError catch (e) {
      debugPrint(e.toString());
      showSnackBar(context, e.toString());
    }
    return null;
  }

  Future<User?> getUserData() async {
    try {
      final preference = _read(sharedPreferencesProvider);
      final token = preference.getString('x-auth-token');

      if (token == null) {
        await preference.setString('x-auth-token', '');
        return null;
      }

      if (token.isEmpty) {
        return null;
      }

      final tokenResponse = await _read(dioProvider).post<bool>(
        '$baseUrl/tokenIsValid',
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        ),
      );

      if (tokenResponse.statusCode == 200) {
        final userResponse = await _read(dioProvider).get<Map<String, dynamic>>(
          '$baseUrl/',
          options: Options(
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token
            },
          ),
        );
        return User.fromJson(userResponse.data!);
      }
    } on DioError catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
