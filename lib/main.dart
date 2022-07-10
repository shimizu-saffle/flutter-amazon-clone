import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'constants/global_variables.dart';
import 'router.dart';
import 'utils/provider_scope.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final overrides = await providerScopeOverrides;
  runApp(
    ProviderScope(
      overrides: overrides,
      child: const AmazonClone(),
    ),
  );
}

class AmazonClone extends ConsumerWidget {
  const AmazonClone({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      title: 'amazon clone',
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        colorScheme: const ColorScheme.light(
          primary: secondaryColor,
        ),
      ),
    );
  }
}
