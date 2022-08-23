import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/auth/auth.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});
  static const routeName = 'home';
  static const routePath = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    return Scaffold(
      body: Center(
        child: Text('${user.name}\n${user.token}'),
      ),
    );
  }
}
