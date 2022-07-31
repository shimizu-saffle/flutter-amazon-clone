// StateNotifier を継承した AuthController を定義する
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/user/user.dart';
import '../../../providers/shared_preferences_provider.dart';
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
    await _read(authRepositoryProvider).signUpUser(user: user);
    onSuccess();
  }

  Future<void> signInUser({
    required String email,
    required String password,
    required VoidCallback onSuccess,
  }) async {
    final currentUser = await _read(authRepositoryProvider).signInUser(
      email: email,
      password: password,
    );
    if (currentUser != null) {
      // TODO(shimizu-saffle): モックユーザーに token を持たせる
      await _read(sharedPreferencesProvider).setString('x-auth-token', currentUser.token!);
      state = currentUser;
      onSuccess();
    }
  }

  Future<void> getUserData() async {
    final currentUser = await _read(authRepositoryProvider).getUserData();
    if (currentUser == null) {
      state = state.copyWith(token: '');
    } else {
      state = currentUser;
    }
  }
}
