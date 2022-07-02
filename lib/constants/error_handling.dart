import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'utils.dart';

void dioErrorHandling({
  required DioError error,
  required BuildContext context,
}) {
  switch (error.response?.statusCode) {
    case 400:
      showSnackBar(
        context,
        error.message,
      );
      break;
    case 500:
      showSnackBar(
        context,
        error.message,
      );
      break;
    case null:
      showSnackBar(
        context,
        error.message,
      );
      break;
    default:
      showSnackBar(
        context,
        'Something went wrong',
      );
      break;
  }
}
