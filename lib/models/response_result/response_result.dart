import 'package:freezed_annotation/freezed_annotation.dart';

part 'response_result.freezed.dart';

@freezed
class ResponseResult<T> with _$ResponseResult<T> {
  const factory ResponseResult({
    required T contents,
    String? message,
    @Default(true) bool success,
  }) = _ResponseResult;

  const factory ResponseResult.failure(dynamic message) = Failure<T>;

  const factory ResponseResult.error(Exception e) = Error<T>;
}
