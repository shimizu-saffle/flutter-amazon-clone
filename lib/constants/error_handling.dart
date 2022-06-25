import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'utils.dart';

void dioErrorHandling({
  required DioError error,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (error.response?.statusCode) {
    case 200:
      onSuccess();
      break;
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
        'Something went wrong',
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
