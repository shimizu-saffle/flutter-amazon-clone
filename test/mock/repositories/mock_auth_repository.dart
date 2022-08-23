import 'package:flutter_amazon_clone/models/response_result/response_result.dart';
import 'package:flutter_amazon_clone/models/user/user.dart';
import 'package:flutter_amazon_clone/repositories/auth_repository.dart';

class MockAuthRepository implements AbstractAuthRepository {
  @override
  Future<ResponseResult<User?>> getUserData() async {
    const mockUserCredentials = <String, dynamic>{
      'name': 'mock name',
      'email': 'test@example.com',
      'password': 'password',
    };
    return ResponseResult.success(
      responseData: User.fromJson(mockUserCredentials),
    );
  }

  @override
  Future<ResponseResult<User?>> signInUser({
    required String email,
    required String password,
  }) async {
    final user = User(
      name: 'mock-name',
      email: email,
      password: password,
      token: 'mock-token',
    );
    return ResponseResult.success(responseData: user);
  }

  @override
  Future<ResponseResult<User?>> signUpUser({required User user}) async {
    return ResponseResult.success(responseData: user);
  }
}
