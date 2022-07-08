import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'domain/auth/pages/auth_page.dart';

final goRouterProvider = Provider<GoRouter>(
  (_) {
    return GoRouter(
      routes: [
        GoRoute(
          path: AuthPage.routePath,
          name: AuthPage.routeName,
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: AuthPage(),
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
