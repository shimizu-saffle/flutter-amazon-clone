import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../constants/global_variables.dart';
import '../../../services/auth_service.dart';

enum AuthStatus {
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
    final authStatus = useState<AuthStatus>(AuthStatus.signUp);
    final authService = ref.watch(authServiceProvider);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final nameController = useTextEditingController();

    return Scaffold(
      backgroundColor: greyBackgroundCOlor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
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
                  tileColor: authStatus.value == AuthStatus.signUp
                      ? backgroundColor
                      : greyBackgroundCOlor,
                  title: const Text(
                    'Create Account',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: Radio(
                    // Widget testで、このRadioを見つけやすくするためにkeyを指定
                    key: const Key('auth_page_radio_button_1'),
                    activeColor: secondaryColor,
                    value: AuthStatus.signUp,
                    groupValue: authStatus.value,
                    onChanged: (AuthStatus? value) => authStatus.value = value!,
                  ),
                ),
                if (authStatus.value == AuthStatus.signUp)
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
                            text: 'Sign Up',
                            onPressed: () {
                              if (signUpFormKey.currentState!.validate()) {
                                authService.signUpUser(
                                  context: context,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ListTile(
                  tileColor: authStatus.value == AuthStatus.signIn
                      ? backgroundColor
                      : greyBackgroundCOlor,
                  title: const Text(
                    'Sing-In',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: Radio(
                    key: const Key('auth_page_radio_button_2'),
                    activeColor: secondaryColor,
                    value: AuthStatus.signIn,
                    groupValue: authStatus.value,
                    onChanged: (AuthStatus? value) => authStatus.value = value!,
                  ),
                ),
                if (authStatus.value == AuthStatus.signIn)
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
      ),
    );
  }
}
