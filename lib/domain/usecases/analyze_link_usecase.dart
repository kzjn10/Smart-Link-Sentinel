import 'package:injectable/injectable.dart';

import '../repositories/generative_repository.dart';
import '../repositories/settings_repository.dart';
import '../models/deeplink_analysis_result.dart';

@injectable
class AnalyzeLinkUseCase {
  final GenerativeRepository _generativeRepository;
  final SettingsRepository _settingsRepository;

  AnalyzeLinkUseCase(
    this._generativeRepository,
    this._settingsRepository,
  );

  Future<DeeplinkAnalysisResult> execute(String link) async {
    final apiKey = await _settingsRepository.getGeminiApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Gemini API Key is not configured. Please add it in Settings.');
    }

    return _generativeRepository.analyzeLink(link: link, apiKey: apiKey);
  }
}
