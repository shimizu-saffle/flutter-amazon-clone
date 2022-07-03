import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants/error_handling.dart';
import '../constants/global_variables.dart';
import '../models/user.dart';
import '../providers/dio.dart';

final authServiceProvider =
    Provider<AuthService>((ref) => AuthService(ref.read));

class AuthService {
  AuthService(this._read);

  final Reader _read;

  Future<void> signUpUser({
    required BuildContext context,
    required VoidCallback onSuccess,
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
      await _read(dioProvider).post<Map<String, dynamic>>(
        '$baseUrl/api/signup',
        data: user.toJson(),
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
        ),
      );
      onSuccess();
    } on DioError catch (e) {
      dioErrorHandling(
        error: e,
        context: context,
      );
      debugPrint(e.toString());
    }
  }
}
