// StateNotifier を継承した AuthController を定義する
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/user/user.dart';
import '../../../services/shared_preferences_provider.dart';
import '../repositories/auth_repository.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, User>((ref) => AuthController(ref.read));

class AuthController extends StateNotifier<User> {
  AuthController(this._read) : super(const User(name: '', email: '', password: '')) {
    getUserData();
  }

  final Reader _read;

  Future<void> signUpUser({
    required String email,
    required String password,
    required String name,
    required VoidCallback onSuccess,
  }) async {
    final user = User(
      email: email,
      password: password,
      name: name,
    );
    final responseResult = await _read(authRepositoryProvider).signUpUser(user: user);
    responseResult.when(
      success: (responseData, message, success) {
        state = responseData!;
        onSuccess();
      },
      failure: (message) async => debugPrint(message),
      error: (e) => debugPrint(e.toString()),
    );
  }

  Future<void> signInUser({
    required String email,
    required String password,
    required VoidCallback onSuccess,
  }) async {
    final response = await _read(authRepositoryProvider).signInUser(
      email: email,
      password: password,
    );
    await response.when(
      success: (responseData, message, success) async {
        final token = responseData!.token;
        await _read(sharedPreferencesProvider).setString('x-auth-token', token!);
        state = responseData;
        onSuccess();
      },
      failure: (message) async {
        debugPrint(message);
      },
      error: (e) {
        debugPrint(e.toString());
      },
    );
  }

  Future<void> getUserData() async {
    final responseResult = await _read(authRepositoryProvider).getUserData();
    responseResult.when(
      success: (responseData, message, success) {
        if (responseData == null) {
          state = state.copyWith(token: '');
        } else {
          state = responseData;
        }
      },
      failure: (message) async => debugPrint(message),
      error: (e) => debugPrint(e.toString()),
    );
  }
}
