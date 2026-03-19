import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'assistant/assistant_screen.dart';
import 'deeplink/deeplink_screen.dart';
import 'history/history_screen.dart';
import 'home/home_screen.dart';
import 'not_found/not_found_screen.dart';
import 'settings/settings_screen.dart';

const String deeplinkRoute = '/deeplink';
const String historyRoute = '/history';
const String assistantRoute = '/assistantRoute';
const String settingsRoute = '/settings';

class AiDeeplinkRouter {
  AiDeeplinkRouter._();

  static GoRouter initRouter({List<NavigatorObserver>? observers}) {
    return GoRouter(
      debugLogDiagnostics: !kReleaseMode,
      observers: observers,
      initialLocation: deeplinkRoute,
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) =>
              HomeScreen(navigationShell: shell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: deeplinkRoute,
                  builder: (context, state) => const DeeplinkScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: historyRoute,
                  builder: (context, state) => const HistoryScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: assistantRoute,
                  builder: (context, state) => const AssistantScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: settingsRoute,
                  builder: (context, state) => const SettingsScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) =>
          NotFoundScreen(errorMessage: state.error.toString()),
      redirect: (context, state) {
        return null;
      },
    );
  }
}
