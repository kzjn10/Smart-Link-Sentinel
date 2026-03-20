import '../models/deeplink_analysis_result.dart';

abstract class GenerativeRepository {
  Future<DeeplinkAnalysisResult> analyzeLink({
    required String link,
    required String apiKey,
  });
}
