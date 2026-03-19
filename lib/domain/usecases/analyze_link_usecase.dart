import 'package:injectable/injectable.dart';

import '../repositories/generative_repository.dart';
import '../repositories/settings_repository.dart';

@injectable
class AnalyzeLinkUseCase {
  final GenerativeRepository _generativeRepository;
  final SettingsRepository _settingsRepository;

  AnalyzeLinkUseCase(
    this._generativeRepository,
    this._settingsRepository,
  );

  Future<void> execute(String link) async {
    final apiKey = await _settingsRepository.getGeminiApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Gemini API Key is not configured. Please add it in Settings.');
    }

    await _generativeRepository.analyzeLink(link: link, apiKey: apiKey);

  }
}
