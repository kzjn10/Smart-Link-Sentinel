import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../core/base/base_view_model.dart';
import '../../../domain/repositories/settings_repository.dart';
import 'settings_state.dart';

@injectable
class SettingsViewModel extends BaseViewModel<SettingsState> {
  final SettingsRepository _settingsRepository;

  SettingsViewModel(this._settingsRepository) : super(const SettingsState()) {
    initData();
  }

  Future<void> initData() async {
    final apiKey = await _settingsRepository.getGeminiApiKey();
    final langCode = await _settingsRepository.getLanguageCode();
    final themeMode = await AdaptiveTheme.getThemeMode();

    emit(state.copyWith(
      geminiApiKey: apiKey,
      languageCode: langCode,
      isDarkMode: themeMode == AdaptiveThemeMode.dark,
    ));
  }

  Future<void> updateGeminiApiKey(String apiKey) async {
    await _settingsRepository.saveGeminiApiKey(apiKey);
    emit(state.copyWith(geminiApiKey: apiKey));
  }

  Future<void> toggleTheme(BuildContext context) async {
    final isDark = !state.isDarkMode;
    if (isDark) {
      AdaptiveTheme.of(context).setDark();
    } else {
      AdaptiveTheme.of(context).setLight();
    }
    emit(state.copyWith(isDarkMode: isDark));
  }

  Future<void> changeLanguage(String? langCode) async {
    await _settingsRepository.saveLanguageCode(langCode);
    emit(state.copyWith(languageCode: langCode));
    // Global locale change will be handled by AiDeeplinkApp listening to a state or just rebuilding
  }
}

