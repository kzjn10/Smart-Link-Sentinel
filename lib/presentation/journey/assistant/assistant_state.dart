import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/base/base_state.dart';
import '../../../domain/models/deeplink_analysis_result.dart';

part 'assistant_state.freezed.dart';

@freezed

abstract class AssistantState with _$AssistantState {
  const factory AssistantState({
    @Default(ViewState.initial) ViewState viewState,
    String? errorMessage,
    @Default(false) bool isSending,
    String? finalUrl,
    String? status,
    bool? isNested,
    NestedLinkDetails? nestedLinkDetails,
    @Default(<String, String>{}) Map<String, String> detectedParams,
    @Default(<String>[]) List<String> validationIssues,
    String? securityWarning,
    String? suggestion,
  }) = _AssistantState;
}

