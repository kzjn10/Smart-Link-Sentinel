import 'package:google_generative_ai/google_generative_ai.dart';

final generateDeepLinkTool = FunctionDeclaration(
  'respond_with_deep_link',
  'Returns the generated Deep Link URL and validation metadata.',
  Schema.object(
    properties: {
      'final_url': Schema.string(
        description: 'The complete, processed, and URL-encoded Deep Link.',
      ),
      'status': Schema.string(
        description:
            'Status of the generation: "SUCCESS", "MISSING_PARAM", or "INVALID_FORMAT".',
      ),
      'detected_params': Schema.object(
        description:
            'Key-value pairs of parameters extracted from the user input.',
        properties: {'key': Schema.string(), 'value': Schema.string()},
      ),
      'security_warning': Schema.string(
        description:
            'Warning message if the link exposes sensitive data; otherwise, empty.',
      ),
      'suggestion': Schema.string(
        description:
            'Contextual suggestion for fixing errors or related test cases.',
      ),
    },
    requiredProperties: ['final_url', 'status'],
  ),
);
