// StateNotifier を継承した AuthController を定義する
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/user/user.dart';
import '../../../providers/shared_preferences_provider.dart';
import '../repositories/auth_repository.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, User>((ref) => AuthController(ref.read));

class AuthController extends StateNotifier<User> {
  AuthController(this._read) : super(const User(name: '', email: '', password: ''));

  final Reader _read;

  Future<void> signInUser({
    required BuildContext context,
    required String email,
    required String password,
    required VoidCallback onSuccess,
  }) async {
    final currentUser = await _read(authRepositoryProvider)
        .signInUser(context: context, email: email, password: password);
    if (currentUser != null) {
      await _read(sharedPreferencesProvider).setString('x-auth-token', currentUser.token);
      state = currentUser;
      onSuccess();
    }
  }
}
