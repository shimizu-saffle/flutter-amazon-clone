import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthPage extends HookConsumerWidget {
  const AuthPage({super.key});
  static const routeName = 'auth';
  static const routePath = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold();
  }
}
