class NestedLinkDetails {
  final String? parameterKey;
  final String? decodedValue;
  final String? internalScheme;
  final bool? isValidInternal;

  const NestedLinkDetails({
    required this.parameterKey,
    required this.decodedValue,
    required this.internalScheme,
    required this.isValidInternal,
  });

  factory NestedLinkDetails.fromToolArgs(Map<String, Object?> args) {
    bool? asBool(Object? value) {
      if (value == null) return null;
      if (value is bool) return value;
      final s = value.toString().toLowerCase();
      if (s == 'true') return true;
      if (s == 'false') return false;
      return null;
    }

    String? asString(Object? value) => value?.toString();

    return NestedLinkDetails(
      parameterKey: asString(args['parameter_key']),
      decodedValue: asString(args['decoded_value']),
      internalScheme: asString(args['internal_scheme']),
      isValidInternal: asBool(args['is_valid_internal']),
    );
  }
}

class DeeplinkAnalysisResult {
  final String? finalUrl;
  final String? status;
  final bool? isNested;
  final NestedLinkDetails? nestedLinkDetails;
  final Map<String, String> detectedParams;
  final List<String> validationIssues;
  final String? securityWarning;
  final String? suggestion;

  const DeeplinkAnalysisResult({
    required this.finalUrl,
    required this.status,
    required this.isNested,
    required this.nestedLinkDetails,
    required this.detectedParams,
    required this.validationIssues,
    required this.securityWarning,
    required this.suggestion,
  });

  factory DeeplinkAnalysisResult.fallback(String? fallbackText) {
    return DeeplinkAnalysisResult(
      finalUrl: fallbackText,
      status: 'UNKNOWN',
      isNested: null,
      nestedLinkDetails: null,
      detectedParams: const {},
      validationIssues: const [],
      securityWarning: null,
      suggestion: null,
    );
  }

  factory DeeplinkAnalysisResult.fromToolArgs(Map<String, Object?> args) {
    String? asString(Object? value) => value?.toString();

    Map<String, String> asStringMap(Object? value) {
      if (value is! Map) return const {};
      return value.map(
        (key, v) => MapEntry(key.toString(), v?.toString() ?? ''),
      );
    }

    bool? asBool(Object? value) {
      if (value == null) return null;
      if (value is bool) return value;
      final s = value.toString().toLowerCase();
      if (s == 'true') return true;
      if (s == 'false') return false;
      return null;
    }

    List<String> asStringList(Object? value) {
      if (value is! List) return const [];
      return value
          .map((e) => e?.toString() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    }

    NestedLinkDetails? parseNestedLinkDetails(Object? value) {
      if (value is! Map) return null;
      return NestedLinkDetails.fromToolArgs(
        value.map((k, v) => MapEntry(k.toString(), v)),
      );
    }

    return DeeplinkAnalysisResult(
      finalUrl: asString(args['final_url']),
      status: asString(args['status']),
      isNested: asBool(args['is_nested']),
      nestedLinkDetails: parseNestedLinkDetails(args['nested_link_details']),
      detectedParams: asStringMap(args['detected_params']),
      validationIssues: asStringList(args['validation_issues']),
      securityWarning: asString(args['security_warning']),
      suggestion: asString(args['suggestion']),
    );
  }
}

