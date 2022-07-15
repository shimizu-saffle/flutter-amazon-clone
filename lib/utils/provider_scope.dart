import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/shared_preferences_provider.dart';

/// RootProviderScope で指定する List<Override> を取得する。
///
/// ProviderScope の overrides したい Provider やその値を列挙する。
///
/// 起動時に一回インスタンス化したキャッシュを使いませせるようにすることで、
///
/// それ以降 await なしでアクセスしたいときなどに便利。
Future<List<Override>> get providerScopeOverrides async {
  return <Override>[
    sharedPreferencesProvider.overrideWithValue(
      await SharedPreferences.getInstance(),
    ),
  ];
}
