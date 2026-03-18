import "package:flutter/material.dart";

import "../../gen/fonts.gen.dart";
import "app_colors.dart";
import "status_colors.dart";

class AiDeeplinkTheme {
  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      surfaceTint: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.accent,
      onSecondary: AppColors.onAccent,
      secondaryContainer: AppColors.accentContainer,
      onSecondaryContainer: AppColors.onAccentContainer,
      tertiary: AppColors.statusDone,
      onTertiary: AppColors.onStatusDone,
      tertiaryContainer: AppColors.statusDoneContainer,
      onTertiaryContainer: AppColors.onStatusDoneContainer,
      error: AppColors.error,
      onError: AppColors.onError,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.onErrorContainer,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: Color(0xFF43474E),
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF2F3033),
      inversePrimary: AppColors.primaryLight,
      surfaceDim: Color(0xFFD9DADF),
      surfaceBright: AppColors.surface,
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF3F3F8),
      surfaceContainer: Color(0xFFEDEDF2),
      surfaceContainerHigh: Color(0xFFE8E8EC),
      surfaceContainerHighest: Color(0xFFE2E2E7),
    );
  }

  ThemeData light() {
    return theme(lightScheme(), StatusColors.light);
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryLight,
      surfaceTint: AppColors.primaryLight,
      onPrimary: AppColors.onPrimaryContainer,
      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: AppColors.primaryContainer,
      secondary: AppColors.accentLight,
      onSecondary: AppColors.onAccentContainer,
      secondaryContainer: Color(0xFF004D55),
      onSecondaryContainer: AppColors.accentContainer,
      tertiary: AppColors.statusDoneLight,
      onTertiary: AppColors.onStatusDoneContainer,
      tertiaryContainer: Color(0xFF005313),
      onTertiaryContainer: AppColors.statusDoneContainer,
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: AppColors.errorContainer,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.onSurfaceDark,
      onSurfaceVariant: Color(0xFFC3C6CF),
      outline: Color(0xFF8D9199),
      outlineVariant: Color(0xFF43474E),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: AppColors.onSurfaceDark,
      inversePrimary: AppColors.primary,
      surfaceDim: Color(0xFF111416),
      surfaceBright: Color(0xFF37393D),
      surfaceContainerLowest: Color(0xFF0C0F11),
      surfaceContainerLow: Color(0xFF191C1E),
      surfaceContainer: Color(0xFF1D2023),
      surfaceContainerHigh: Color(0xFF282A2D),
      surfaceContainerHighest: Color(0xFF333538),
    );
  }

  ThemeData dark() {
    return theme(darkScheme(), StatusColors.dark);
  }

  NavigationBarThemeData get _navigationBarTheme => NavigationBarThemeData(
    labelTextStyle: WidgetStateProperty.all(
      const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    ),
  );

  ThemeData theme(ColorScheme colorScheme, StatusColors statusColors) =>
      ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
        fontFamily: AiDeeplinkFont.googleSans,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        extensions: [statusColors],
        navigationBarTheme: _navigationBarTheme,
      );
}
