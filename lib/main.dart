import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

import 'di/injection.dart';
import 'presentation/journey/ai_deeplink_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configurationDependencies();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  runApp(AiDeeplinkApp(savedThemeMode));
}
