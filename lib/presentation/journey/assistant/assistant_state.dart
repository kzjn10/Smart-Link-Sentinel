import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/base/base_state.dart';

part 'assistant_state.freezed.dart';

@freezed

abstract class AssistantState with _$AssistantState {
  const factory AssistantState({
    @Default(ViewState.initial) ViewState viewState,
    String? errorMessage,
    String? languageCode,
  }) = _AssistantState;
}

