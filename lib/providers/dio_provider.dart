import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final dioProvider = Provider(
  (_) => Dio(
      // BaseOptions(baseUrl: 'http://192.168.1.2:3000'),
      ),
  // dependencies: [authRepositoryProvider],
);
