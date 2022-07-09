import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'utils.dart';

void dioErrorHandling({
  required Response<dynamic> response,
  required BuildContext context,
  VoidCallback? onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess?.call();
      break;
    case 400:
      showSnackBar(
        context,
        response.statusMessage!,
      );
      break;
    case 500:
      showSnackBar(
        context,
        response.statusMessage!,
      );
      break;
    case null:
      showSnackBar(
        context,
        response.statusMessage!,
      );
      break;
    default:
      showSnackBar(
        context,
        response.toString(),
      );
  }
}
