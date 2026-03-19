import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../di/injection.dart';
import '../../../extensions/context_extensions.dart';
import '../../shared_cubit/locale_cubit.dart';
import '../../widget/x_bottom_sheet_content.dart';
import '../../widget/x_input_key_text_field.dart';
import '../../widget/x_state_widget.dart';
import 'settings_view_model.dart';

const String _geminiApiKeyUrl = 'https://aistudio.google.com/api-keys';

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
    final borderRadius = BorderRadius.circular(12);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n?.common_text_settings ?? '')),
      body: SingleChildScrollView(
        padding: const .symmetric(vertical: 24.0, horizontal: 16),
        child: Material(
          elevation: 0,
          borderRadius: borderRadius,
          color: context.surfaceContainerLowColor,
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: Border.all(color: context.primaryColor.withAlpha(20)),
            ),
            child: Column(
              children: [
                _buildMenuItem(
                  context,
                  title: context.l10n?.settings_ai_key ?? '',
                  subtitle:
                      context.select(
                        (SettingsViewModel viewModel) =>
                            viewModel.state.geminiApiKey?.isNotEmpty == true,
                      )
                      ? '••••••••'
                      : context.l10n?.settings_hint_ai_key,
                  icon: Icons.key,
                  onTap: () {
                    final geminiApiKey = context
                        .read<SettingsViewModel>()
                        .state
                        .geminiApiKey;
                    _showApiKeyBottomSheet(context, geminiApiKey);
                  },
                ),
                Builder(
                  builder: (context) {
                    final isDarkMode = context.select(
                      (SettingsViewModel viewModel) =>
                          viewModel.state.isDarkMode,
                    );
                    return SwitchListTile(
                      title: Text(context.l10n?.settings_theme ?? ''),
                      subtitle: Text(
                        isDarkMode
                            ? (context.l10n?.settings_text_darkMode ?? '')
                            : (context.l10n?.settings_text_lightMode ?? ''),
                      ),
                      secondary: Icon(
                        isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      ),
                      value: isDarkMode,
                      onChanged: (value) {
                        context.read<SettingsViewModel>().toggleTheme(context);
                      },
                    );
                  },
                ),
                Builder(
                  builder: (context) {
                    final languageCode = context.select(
                      (SettingsViewModel viewModel) =>
                          viewModel.state.languageCode,
                    );
                    return _buildMenuItem(
                      context,
                      title: context.l10n?.settings_language,
                      subtitle: languageCode == 'vi'
                          ? (context.l10n?.settings_language_vi ?? '')
                          : (context.l10n?.settings_language_en ?? ''),
                      icon: Icons.language,
                      onTap: () =>
                          _showLanguageBottomSheet(context, languageCode),
                    );
                  },
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
      title: context.l10n?.settings_ai_key,
      child: Padding(
        padding: .symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          children: [
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: context.tertiaryFixedDimColor.withAlpha(100),
                borderRadius: .circular(12),
              ),
              child: XInputKeyTextField(
                controller: _apiKeyController,
                labelText: context.l10n?.common_label_geminiApiKey,
                hintText: context.l10n?.settings_hint_ai_key,
                obscureText: true,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              spacing: 4,
              children: [
                Icon(Icons.info_sharp, color: context.tertiaryFixedDimColor),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: context.l10n?.settings_text_tapHere,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.primaryColor.withAlpha(200),
                            fontWeight: .bold,
                            decoration: .underline,
                            decorationColor: context.primaryColor.withAlpha(
                              200,
                            ),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _launchURL(_geminiApiKeyUrl);
                            },
                        ),
                        TextSpan(
                          text: context.l10n?.settings_text_getGeminiApiKey,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.primaryColor.withAlpha(200),
                            fontWeight: .bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }
}
