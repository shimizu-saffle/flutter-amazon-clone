import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/constants/global_variables.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'selectedNavBarColor test',
    () {
      expect(selectedNavBarColor, Colors.cyan[800]);
    },
  );
}
