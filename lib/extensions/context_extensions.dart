import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

extension ContextExtensions on BuildContext {
  AppLocalizations? get l10n => AppLocalizations.of(this);

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  Color get primaryColor => theme.colorScheme.primary;

  Color get secondaryColor => theme.colorScheme.secondary;

  Color get tertiaryColor => theme.colorScheme.tertiary;

  Color get errorColor => theme.colorScheme.error;

  Color get tertiaryFixedDimColor => theme.colorScheme.tertiaryFixedDim;

  Color get secondaryContainer => theme.colorScheme.surfaceContainerLow;
}
