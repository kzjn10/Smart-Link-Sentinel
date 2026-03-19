import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/base/base_state.dart';

part 'settings_state.freezed.dart';

@freezed

abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(ViewState.initial) ViewState viewState,
    String? errorMessage,
    String? geminiApiKey,
    @Default(false) bool isDarkMode,
    String? languageCode,
  }) = _SettingsState;
}

