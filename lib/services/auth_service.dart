import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../constants/error_handling.dart';
import '../constants/global_variables.dart';
import '../models/user.dart';

class AuthService {
  Future<void> signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final dio = Dio();
      final user = User(
        email: email,
        password: password,
        name: name,
      );
      await dio.post<User?>(
        '$baseUrl/api/signup',
        data: user.toJson(),
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
        ),
      );
    } on DioError catch (e) {
      dioErrorHandling(
        error: e,
        context: context,
      );
    }
  }
}
