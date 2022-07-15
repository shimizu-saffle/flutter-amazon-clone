import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'domain/auth/controllers/auth_controller.dart';
import 'domain/auth/pages/auth_page.dart';
import 'domain/home/pages/home_page.dart';

final routerProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      routes: [
        GoRoute(
          path: AuthPage.routePath,
          name: AuthPage.routeName,
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: AuthPage(),
          ),
          redirect: (state) {
            final isLoggedIn = ref.watch(authControllerProvider).token.isNotEmpty;
            if (isLoggedIn) {
              return HomePage.routePath;
            }
            return null;
          },
        ),
        GoRoute(
          path: HomePage.routePath,
          name: HomePage.routeName,
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const HomePage(),
          ),
        ),
      ],
      errorPageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          body: Center(
            child: Text(state.error.toString()),
          ),
        ),
      ),
    );
  },
);
