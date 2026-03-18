import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../theme/theme.dart';
import 'router.dart';

class AiDeeplinkApp extends StatefulWidget {
  const AiDeeplinkApp({super.key});

  @override
  State<AiDeeplinkApp> createState() => _AiDeeplinkAppState();
}

class _AiDeeplinkAppState extends State<AiDeeplinkApp> {
  late final GoRouter router;

  @override
  void initState() {
    super.initState();
    router = AiDeeplinkRouter.initRouter();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AI Deeplink Tester',
      theme: AiDeeplinkTheme().light(),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
