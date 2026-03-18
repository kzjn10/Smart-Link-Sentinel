import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/base/base_state.dart';

part 'deeplink_state.freezed.dart';

@freezed
abstract class DeeplinkState with _$DeeplinkState {
  const factory DeeplinkState({
    @Default(ViewState.initial) ViewState viewState,
    @Default({}) Map<String, dynamic> parsedData,
    @Default({}) Map<String, dynamic> queryParameters,
    @Default('') String resourceIdentifier,
    String? errorMessage,
  }) = _DeeplinkState;
}
