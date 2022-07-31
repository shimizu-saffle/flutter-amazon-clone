import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockGoRouter extends Mock implements GoRouter {
  /// go()メソッドが呼ばれたURLのリスト
  final calledLocations = <String>[];

  @override
  void go(String location, {Object? extra}) {
    calledLocations.add(location);
  }
}
