import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

class AppLogger {
  AppLogger._();

  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log(message, name: tag ?? 'AiDeeplink');
    }
  }

  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      developer.log(
        message,
        name: tag ?? 'AiDeeplink',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
