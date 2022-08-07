import 'package:freezed_annotation/freezed_annotation.dart';

part 'response_result.freezed.dart';

@freezed
class ResponseResult<T> with _$ResponseResult<T> {
  const factory ResponseResult.success({
    required T responseData,
    String? message,
    @Default(true) bool success,
  }) = _ResponseResult;

  const factory ResponseResult.failure({
    @Default('サーバとの通信に失敗しました。') String message,
  }) = Failure<T>;

  const factory ResponseResult.error(Exception e) = Error<T>;
}
