import 'package:flutter/material.dart';

import 'di/injection.dart';
import 'presentation/journey/ai_deeplink_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configurationDependencies();
  runApp(const AiDeeplinkApp());
}
