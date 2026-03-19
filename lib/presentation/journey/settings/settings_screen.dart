import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../di/injection.dart';
import '../../../extensions/context_extensions.dart';
import '../../shared_cubit/locale_cubit.dart';
import '../../widget/x_bottom_sheet_content.dart';
import '../../widget/x_input_key_text_field.dart';
import '../../widget/x_state_widget.dart';
import 'settings_state.dart';
import 'settings_view_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SettingsViewModel>(),
      child: const _SettingScreenView(),
    );
  }
}

class _SettingScreenView extends StatefulWidget {
  const _SettingScreenView();

  @override
  State<_SettingScreenView> createState() => _SettingScreenViewState();
}

class _SettingScreenViewState extends XStateWidget<_SettingScreenView> {
  final _apiKeyController = TextEditingController();

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n?.common_text_settings ?? '')),
      body: BlocBuilder<SettingsViewModel, SettingsState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Material(
              elevation: 0,
              borderRadius: .circular(12),
              color: context.secondaryContainer,
              clipBehavior: .antiAlias,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.primaryColor.withAlpha(20)),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      context,
                      title: context.l10n?.settings_ai_key ?? 'Gemini API Key',
                      subtitle: state.geminiApiKey?.isNotEmpty == true
                          ? '••••••••'
                          : context.l10n?.settings_hint_ai_key,
                      icon: Icons.key,
                      onTap: () =>
                          _showApiKeyBottomSheet(context, state.geminiApiKey),
                    ),
                    SwitchListTile(
                      title: Text(context.l10n?.settings_theme ?? 'Theme'),
                      subtitle: Text(
                        state.isDarkMode
                            ? (context.l10n?.settings_text_dark_mode ??
                                  'Dark Mode')
                            : (context.l10n?.settings_text_light_mode ??
                                  'Light Mode'),
                      ),
                      secondary: Icon(
                        state.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      ),
                      value: state.isDarkMode,
                      onChanged: (value) {
                        context.read<SettingsViewModel>().toggleTheme(context);
                      },
                    ),
                    _buildMenuItem(
                      context,
                      title: context.l10n?.settings_language,
                      subtitle: state.languageCode == 'vi'
                          ? (context.l10n?.settings_language_vi ?? 'Tiếng Việt')
                          : (context.l10n?.settings_language_en ?? 'English'),
                      icon: Icons.language,
                      onTap: () =>
                          _showLanguageBottomSheet(context, state.languageCode),
                    ),
                    _buildMenuItem(
                      context,
                      title: context.l10n?.settings_about,
                      icon: Icons.info_outline,
                      onTap: () async {
                        _showAboutDialog(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    String? title,
    String? subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title ?? ''),
      subtitle: subtitle != null ? Text(subtitle) : null,
      leading: Icon(icon),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  FutureOr<void> _showApiKeyBottomSheet(
    BuildContext context,
    String? currentKey,
  ) async {
    _apiKeyController.text = currentKey ?? '';
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return _buildApiKeyBottomSheetContent(bottomSheetContext);
      },
    );
  }

  Widget _buildApiKeyBottomSheetContent(BuildContext sheetContext) {
    return XBottomSheetContent(
      padding: EdgeInsets.zero,
      height: context.deviceHeight * 0.3,
      title: context.l10n?.settings_ai_key,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: context.tertiaryFixedDimColor.withAlpha(100),
                borderRadius: BorderRadius.circular(12),
              ),
              child: XInputKeyTextField(
                controller: _apiKeyController,
                labelText: context.l10n?.common_label_geminiApiKey,
                hintText: context.l10n?.settings_hint_ai_key,
                obscureText: true,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                context.read<SettingsViewModel>().updateGeminiApiKey(
                  _apiKeyController.text,
                );
                Navigator.pop(sheetContext);
                showSnackBar(context, context.l10n?.settings_api_key_saved);
              },
              child: Text(context.l10n?.settings_save ?? 'Save'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  FutureOr<void> _showLanguageBottomSheet(
    BuildContext context,
    String? currentLang,
  ) async {
    await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: .vertical(top: .circular(20)),
      ),
      builder: (_) =>
          _buildLanguageBottomSheetContent(context, currentLang: currentLang),
    );
  }

  Widget _buildLanguageBottomSheetContent(
    BuildContext sheetContext, {
    required String? currentLang,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: XBottomSheetContent(
        padding: EdgeInsets.zero,
        height: context.deviceHeight * 0.3,
        title: context.l10n?.settings_language,
        child: Column(
          children: [
            const SizedBox(height: 20),
            ListTile(
              title: Text(context.l10n?.settings_language_en ?? 'English'),
              trailing: (currentLang == null || currentLang == 'en')
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                context.read<SettingsViewModel>().changeLanguage('en');
                getIt<LocaleCubit>().changeLocale('en');
                Navigator.pop(sheetContext);
              },
            ),
            ListTile(
              title: Text(context.l10n?.settings_language_vi ?? 'Tiếng Việt'),
              trailing: currentLang == 'vi' ? const Icon(Icons.check) : null,
              onTap: () {
                context.read<SettingsViewModel>().changeLanguage('vi');
                getIt<LocaleCubit>().changeLocale('vi');
                Navigator.pop(sheetContext);
              },
            ),
          ],
        ),
      ),
    );
  }

  FutureOr<void> _showAboutDialog(BuildContext context) async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (context.mounted) {
      showAboutDialog(
        context: context,
        applicationName: context.l10n?.app_name,
        applicationLegalese: context.l10n?.common_message_phanes,
        children: [
          const SizedBox(height: 8),
          Text(context.l10n?.common_message_appInfo ?? ''),
        ],
        applicationVersion: packageInfo.version,
        // applicationIcon: Image.asset(
        //   LotoAssets.graphics.ic182.path,
        //   width: 64,
        //   height: 64,
        // ),
      );
    }
  }
}
