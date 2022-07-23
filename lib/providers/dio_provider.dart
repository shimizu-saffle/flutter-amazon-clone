import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final dioProvider = Provider(
  (_) => Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.5:3000',
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
    ),
  ),
);
