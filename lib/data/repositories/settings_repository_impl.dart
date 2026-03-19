import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/settings_repository.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences _prefs;

  SettingsRepositoryImpl(this._prefs);

  static const String _geminiApiKey = 'gemini_api_key';
  static const String _languageCode = 'language_code';

  @override
  Future<String?> getGeminiApiKey() async {
    return _prefs.getString(_geminiApiKey);
  }

  @override
  Future<void> saveGeminiApiKey(String apiKey) async {
    await _prefs.setString(_geminiApiKey, apiKey);
  }

  @override
  Future<String?> getLanguageCode() async {
    return _prefs.getString(_languageCode);
  }

  @override
  Future<void> saveLanguageCode(String? languageCode) async {
    if (languageCode == null) {
      await _prefs.remove(_languageCode);
    } else {
      await _prefs.setString(_languageCode, languageCode);
    }
  }
}
