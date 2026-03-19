abstract class SettingsRepository {
  Future<String?> getGeminiApiKey();

  Future<void> saveGeminiApiKey(String apiKey);

  Future<String?> getLanguageCode();

  Future<void> saveLanguageCode(String? languageCode);
}
