import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../constants/global_variables.dart';

enum Auth {
  signIn,
  signUp,
}

class AuthPage extends HookConsumerWidget {
  AuthPage({super.key});
  static const routeName = 'auth';
  static const routePath = '/';
  final signUpFormKey = GlobalKey<FormState>();
  final signInFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = useState<Auth>(Auth.signUp);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final nameController = useTextEditingController();

    return Scaffold(
      backgroundColor: greyBackgroundCOlor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              ListTile(
                tileColor: auth.value == Auth.signUp
                    ? backgroundColor
                    : greyBackgroundCOlor,
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
              if (auth.value == Auth.signUp)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: backgroundColor,
                  child: Form(
                    key: signUpFormKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: nameController,
                          hintText: 'Name',
                        ),
                        const Gap(10),
                        CustomTextField(
                          controller: emailController,
                          hintText: 'Email',
                        ),
                        const Gap(10),
                        CustomTextField(
                          controller: passwordController,
                          hintText: 'Password',
                        ),
                        const Gap(10),
                        CustomButton(
                          onPressed: () {},
                          text: 'Sign Up',
                        ),
                      ],
                    ),
                  ),
                ),
              ListTile(
                tileColor: auth.value == Auth.signIn
                    ? backgroundColor
                    : greyBackgroundCOlor,
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
              if (auth.value == Auth.signIn)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: backgroundColor,
                  child: Form(
                    key: signUpFormKey,
                    child: Column(
                      children: [
                        const Gap(10),
                        CustomTextField(
                          controller: emailController,
                          hintText: 'Email',
                        ),
                        const Gap(10),
                        CustomTextField(
                          controller: passwordController,
                          hintText: 'Password',
                        ),
                        const Gap(10),
                        CustomButton(
                          onPressed: () {},
                          text: 'Sign In',
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
