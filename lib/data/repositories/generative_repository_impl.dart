import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:injectable/injectable.dart';

import '../../core/constant/app_constant.dart';
import '../../domain/models/deeplink_analysis_result.dart';
import '../../domain/repositories/generative_repository.dart';

const String _systemInstruction = 'assets/prompts/system_instruction.md';

@Injectable(as: GenerativeRepository)
class GenerativeRepositoryImpl implements GenerativeRepository {
  @override
  Future<DeeplinkAnalysisResult> analyzeLink({
    required String link,
    required String apiKey,
  }) async {
    final systemInstructionText = await loadSystemInstruction();
    final model = GenerativeModel(
      model: 'gemini-3-flash-preview',
      apiKey: apiKey,
      systemInstruction: Content.system(systemInstructionText),
      tools: [
        Tool(functionDeclarations: [generateDeepLinkTool]),
      ],
      toolConfig: ToolConfig(
        functionCallingConfig: FunctionCallingConfig(
          mode: FunctionCallingMode.any,
          allowedFunctionNames: {generateDeepLinkTool.name},
        ),
      ),
    );

    final response = await model.generateContent([Content.text(link)]);
    for (final call in response.functionCalls) {
      if (call.name == generateDeepLinkTool.name) {
        return DeeplinkAnalysisResult.fromToolArgs(call.args);
      }
    }

    String? fallbackText;
    try {
      fallbackText = response.text?.trim();
    } catch (_) {
      fallbackText = null;
    }

    return DeeplinkAnalysisResult.fallback(fallbackText);
  }

  String? _systemInstructionCache;

  Future<String> loadSystemInstruction() async {
    if (_systemInstructionCache != null) return _systemInstructionCache!;

    _systemInstructionCache = await rootBundle.loadString(_systemInstruction);
    return _systemInstructionCache!;
  }
}
