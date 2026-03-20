import 'package:google_generative_ai/google_generative_ai.dart';

final generateDeepLinkTool = FunctionDeclaration(
  'respond_with_deep_link',
  'Parses, heals, and validates deep links, app links, and smart links, providing structured metadata and security audits.',
  Schema.object(
    properties: {
      'final_url': Schema.string(
        description: 'The sanitized, healed, and fully URL-encoded final link ready for testing.',
      ),
      'status': Schema.string(
        description: 'Result status: "SUCCESS", "NON_STANDARD", "MISSING_PARAM", "INVALID_FORMAT", or "ERROR".',
      ),
      'is_nested': Schema.boolean(
        description: 'True if the link contains a nested deep link within parameters like cp_0, url, or deeplink_path.',
      ),
      'nested_link_details': Schema.object(
        description: 'Analysis of the internal link found within the parent URL.',
        properties: {
          'parameter_key': Schema.string(description: 'The key containing the nested link (e.g., "cp_0")'),
          'decoded_value': Schema.string(description: 'The raw decoded value of the nested deep link.'),
          'internal_scheme': Schema.string(description: 'The scheme of the nested link (e.g., "amzn").'),
          'is_valid_internal': Schema.boolean(description: 'Whether the nested structure is logically consistent.'),
        },
      ),
      'detected_params': Schema.object(
        description: 'Key-value map of all parameters extracted from the input.', properties: {},
      ),
      'validation_issues': Schema.array(
        items: Schema.string(),
        description: 'List of issues found: e.g., "Insecure HTTP used", "Missing site_id", "Double encoding required".',
      ),
      'security_warning': Schema.string(
        description: 'Warning message if PII, tokens, or passwords are detected in the URL parameters.',
      ),
      'suggestion': Schema.string(
        description: 'Proactive technical advice to fix the link or improve its standardization for production.',
      ),
    },
    requiredProperties: ['final_url', 'status'],
  ),
);