import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

/// モック版のGoRouter
class MockGoRouter extends Mock implements GoRouter {
  /// go()メソッドが呼ばれたURLのリスト
  final calledLocations = <String>[];

  @override
  void go(String location, {Object? extra}) {
    calledLocations.add(location);
  }
}

class MockGoRouterProvider extends StatelessWidget {
  const MockGoRouterProvider({
    required this.goRouter,
    required this.child,
    super.key,
  });

  final MockGoRouter goRouter;

  final Widget child;

  @override
  Widget build(BuildContext context) => InheritedGoRouter(
        goRouter: goRouter,
        child: child,
      );
}
