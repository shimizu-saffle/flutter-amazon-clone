import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/global_variables.dart';

enum Auth {
  signIn,
  signUp,
}

class AuthPage extends HookConsumerWidget {
  const AuthPage({super.key});
  static const routeName = 'auth';
  static const routePath = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = useState<Auth>(Auth.signUp);
    return Scaffold(
      backgroundColor: greyBackgroundCOlor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              ListTile(
                title: const Text(
                  'Create Account',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: Radio(
                  activeColor: secondaryColor,
                  value: Auth.signUp,
                  groupValue: auth.value,
                  onChanged: (Auth? value) => auth.value = value!,
                ),
              ),
              ListTile(
                title: const Text(
                  'Sing-In',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: Radio(
                  activeColor: secondaryColor,
                  value: Auth.signIn,
                  groupValue: auth.value,
                  onChanged: (Auth? value) => auth.value = value!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
