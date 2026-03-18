import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/base/base_state.dart';
import '../../../core/utils/app_logger.dart';
import '../../../di/injection.dart';
import '../../../extensions/context_extensions.dart';
import '../../widget/x_input_code_text_field.dart';
import '../../widget/x_state_widget.dart';
import 'deeplink_state.dart';
import 'deeplink_view_model.dart';

class DeeplinkScreen extends StatelessWidget {
  const DeeplinkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DeeplinkViewModel>(),
      child: const _DeeplinkScreenView(),
    );
  }
}

class _DeeplinkScreenView extends StatefulWidget {
  const _DeeplinkScreenView();

  @override
  State<_DeeplinkScreenView> createState() => _DeeplinkScreenViewState();
}

class _DeeplinkScreenViewState extends XStateWidget<_DeeplinkScreenView> {
  final TextEditingController _deeplinkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _deeplinkController.addListener(() {
      if (mounted) {
        context.read<DeeplinkViewModel>().onLinkChanged(
          _deeplinkController.text,
        );
      }
    });
  }

  @override
  void dispose() {
    _deeplinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n?.common_text_resourceIdentifiers ?? ''),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.tertiaryFixedDimColor.withAlpha(100),
                borderRadius: BorderRadius.circular(12),
              ),
              child: XDeeplinkTextField(
                inputCodeController: _deeplinkController,
                hintText: context.l10n?.common_hint_deeplink,
              ),
            ),
            FilledButton(
              onPressed: () async {
                context.read<DeeplinkViewModel>().addOrUpdateHistory(
                  _deeplinkController.text,
                );
                await _launchUrl(_deeplinkController.text);
              },
              child: Text(context.l10n?.common_text_openDeeplink ?? ''),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: BlocConsumer<DeeplinkViewModel, DeeplinkState>(
                  listenWhen: (previous, current) =>
                      previous.viewState != current.viewState,
                  listener: (context, state) {
                    if (state.viewState == ViewState.error) {
                      showErrorSnackBar(
                        context,
                        context.l10n?.common_message_failedToParseDeeplink,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state.resourceIdentifier.isEmpty) {
                      return SizedBox.shrink();
                    }
                    if (state.viewState == ViewState.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: context.primaryColor),
                      ),
                      child: Column(
                        children: [
                          _SectionHeader(
                            title: context.l10n?.common_text_urlParts ?? '',
                          ),
                          ...state.parsedData.entries.map(
                            (e) => _ElementRow(label: e.key, value: e.value),
                          ),
                          if (state.queryParameters.entries.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            _SectionHeader(
                              title:
                                  context.l10n?.common_text_queryString ?? '',
                            ),
                            ...state.queryParameters.entries.map(
                              (e) => _ElementRow(label: e.key, value: e.value),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String resourceIdentifier) async {
    try {
      if (!await launchUrl(Uri.parse(resourceIdentifier))) {
        throw Exception('Could not launch $resourceIdentifier');
      }
    } catch (e) {
      AppLogger.error(e.toString());
      if (mounted) {
        showErrorSnackBar(
          context,
          context.l10n?.common_message_noAppFoundToHandleDeepLink,
        );
      }
    }
  }
}

// ─────────────────────────────────────────────
// Section header
// ─────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            title,
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.primaryColor,
            ),
          ),
          Divider(color: context.primaryColor.withAlpha(50)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Element row
// ─────────────────────────────────────────────
class _ElementRow extends StatelessWidget {
  const _ElementRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: .start,
        mainAxisAlignment: .start,
        spacing: 4,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 7,
            child: SelectableText(value, style: context.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
