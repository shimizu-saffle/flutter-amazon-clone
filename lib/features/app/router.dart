import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../auth/controllers/auth_controller.dart';
import '../auth/pages/auth_page.dart';
import '../home/pages/home_page.dart';
import 'pages/loading_page.dart';

final routerProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      redirect: (state) {
        final path = state.subloc;
        final authController = ref.watch(authControllerProvider);
        final authToken = authController.token;
        if (authToken == null) {
          return null;
        }
        if (authToken.isNotEmpty) {
          switch (path) {
            case LoadingPage.routePath:
              return HomePage.routePath;
          }
        }
        if (authToken.isEmpty) {
          switch (path) {
            case LoadingPage.routePath:
              return AuthPage.routePath;
          }
        }
        return null;
      },
      routes: [
        GoRoute(
          path: LoadingPage.routePath,
          name: LoadingPage.routeName,
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const LoadingPage(),
          ),
        ),
        GoRoute(
          path: AuthPage.routePath,
          name: AuthPage.routeName,
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: AuthPage(),
          ),
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
