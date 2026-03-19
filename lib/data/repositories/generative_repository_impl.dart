import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:injectable/injectable.dart';

import '../../core/constant/app_constant.dart';
import '../../domain/repositories/generative_repository.dart';

@Injectable(as: GenerativeRepository)
class GenerativeRepositoryImpl implements GenerativeRepository {

  @override
  Future<void> analyzeLink({
    required String link,
    required String apiKey,
  }) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.system(systemInstruction),
      tools: [
        Tool(functionDeclarations: [respondWithProductsTool]),
      ],
      toolConfig: ToolConfig(
        functionCallingConfig: FunctionCallingConfig(
          mode: FunctionCallingMode.any,
          allowedFunctionNames: {'respond_with_products'},
        ),
      ),
    );

    final response = await model.generateContent([Content.text(link)]);
  }
}
