import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../extensions/context_extensions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.link),
            selectedIcon: Icon(Icons.link_sharp),
            label: context.l10n?.common_text_resourceIdentifiers ?? '',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            selectedIcon: Icon(Icons.history_rounded),
            label: context.l10n?.common_text_history ?? '',
          ),
          NavigationDestination(
            icon: Icon(Icons.assistant_rounded),
            selectedIcon: Icon(Icons.assistant_rounded),
            label: context.l10n?.common_text_assistant ?? '',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            selectedIcon: Icon(Icons.settings),
            label: context.l10n?.common_text_settings ?? '',
          ),
        ],
      ),
    );
  }
}
