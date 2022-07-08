import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/controllers/auth_controller.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});
  static const routeName = 'home';
  static const String routePath = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider);
    return Scaffold(
      body: Center(
        child: Text('${user.name}\n${user.token}'),
      ),
    );
  }
}
