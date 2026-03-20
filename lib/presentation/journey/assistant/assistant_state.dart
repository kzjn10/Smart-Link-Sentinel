import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/base/base_state.dart';

part 'assistant_state.freezed.dart';

@freezed

abstract class AssistantState with _$AssistantState {
  const factory AssistantState({
    @Default(ViewState.initial) ViewState viewState,
    String? errorMessage,
    @Default(false) bool isSending,
    String? finalUrl,
    String? status,
    @Default(<String, String>{}) Map<String, String> detectedParams,
    String? securityWarning,
    String? suggestion,
  }) = _AssistantState;
}

