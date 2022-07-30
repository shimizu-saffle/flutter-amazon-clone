import 'package:flutter_amazon_clone/domain/auth/repositories/auth_repository.dart';
import 'package:flutter_amazon_clone/models/user/user.dart';

class MockAuthRepository implements AbstractAuthRepository {
  @override
  Future<User?> getUserData() {
    // TODO: implement getUserData
    throw UnimplementedError();
  }

  @override
  Future<User?> signInUser({required String email, required String password}) {
    // TODO: implement signInUser
    throw UnimplementedError();
  }

  @override
  Future<void> signUpUser({required User user}) {
    // TODO: implement signUpUser
    throw UnimplementedError();
  }
}
