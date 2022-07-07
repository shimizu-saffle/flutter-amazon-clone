import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../models/user/user.dart';
import '../../../providers/dio.dart';

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

  Future<void> signInUser({
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
      debugPrint(response.toString());
      dioErrorHandling(
        response: response,
        context: context,
        onSuccess: () {},
      );
    } on DioError catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
