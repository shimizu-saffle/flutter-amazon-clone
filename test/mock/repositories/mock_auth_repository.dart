import 'package:flutter_amazon_clone/domain/auth/repositories/auth_repository.dart';
import 'package:flutter_amazon_clone/models/user/user.dart';

class MockAuthRepository implements AbstractAuthRepository {
  @override
  Future<User?> getUserData() async {
    const mockUserCredentials = <String, dynamic>{
      'name': 'mock name',
      'email': 'test@example.com',
      'password': 'password',
    };
    return User.fromJson(mockUserCredentials);
  }

  @override
  Future<User?> signInUser({
    required String email,
    required String password,
  }) async {
    final user = User(
      name: 'mock-name',
      email: email,
      password: password,
      token: 'mock-token',
    );
    return user;
  }

  @override
  Future<void> signUpUser({required User user}) async {}
}
