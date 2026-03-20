import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';


import '../../di/injection.dart';
import '../../l10n/app_localizations.dart';
import '../theme/theme.dart';
import 'router.dart';
import '../shared_cubit/locale_cubit.dart';


class AiDeeplinkApp extends StatefulWidget {
  const AiDeeplinkApp(this.savedThemeMode, {super.key});

  final AdaptiveThemeMode? savedThemeMode;

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
    final themeData = AiDeeplinkTheme();
    return BlocProvider(
      create: (context) => getIt<LocaleCubit>(),
      child: AdaptiveTheme(
        light: themeData.light(),
        dark: themeData.dark(),
        initial: widget.savedThemeMode ?? AdaptiveThemeMode.light,
        builder: (theme, darkTheme) {
          return BlocBuilder<LocaleCubit, String?>(
            builder: (context, langCode) {
              return MaterialApp.router(
                title: 'Smart Link Sentinel',
                theme: theme,
                darkTheme: darkTheme,
                locale: langCode != null ? Locale(langCode) : null,
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
            },
          );
        },
      ),
    );
  }
}

