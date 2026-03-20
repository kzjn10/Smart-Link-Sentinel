import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/base/base_state.dart';
import '../../../core/utils/app_logger.dart';
import '../../../di/injection.dart';
import '../../../extensions/context_extensions.dart';
import '../../../extensions/qr_scan_extension.dart';
import '../../widget/widget.dart';
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
  final TextEditingController _linkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _linkController.addListener(() {
      if (mounted) {
        context.read<DeeplinkViewModel>().onLinkChanged(_linkController.text);
      }
    });
  }

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n?.common_text_resourceIdentifiers ?? ''),
        actions: [
          IconButton(
            onPressed: () {
              context.scanQrCodeToController(_linkController);
            },
            icon: Icon(Icons.qr_code_scanner),
          ),
        ],
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
                inputCodeController: _linkController,
                hintText: context.l10n?.common_hint_deeplink,
              ),
            ),
            BlocBuilder<DeeplinkViewModel, DeeplinkState>(
              buildWhen: (previous, current) =>
                  previous.resourceIdentifier.isEmpty !=
                  current.resourceIdentifier.isEmpty,
              builder: (context, state) {
                return FilledButton(
                  onPressed: state.resourceIdentifier.isEmpty
                      ? null
                      : () async {
                          context.read<DeeplinkViewModel>().addOrUpdateHistory(
                            _linkController.text,
                          );
                          await _launchUrl(_linkController.text);
                        },
                  child: Text(context.l10n?.common_text_openDeeplink ?? ''),
                );
              },
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
                  buildWhen: (previous, current) =>
                      previous.viewState != current.viewState ||
                      previous.resourceIdentifier !=
                          current.resourceIdentifier ||
                      previous.parsedData != current.parsedData ||
                      previous.queryParameters != current.queryParameters,
                  builder: (context, state) {
                    if (state.resourceIdentifier.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    if (state.viewState == ViewState.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Container(
                      padding: const .symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: .circular(12),
                        border: Border.all(
                          color: context.primaryColor.withAlpha(100),
                        ),
                      ),
                      child: Column(
                        children: [
                          SectionHeader(
                            title: context.l10n?.common_text_urlParts ?? '',
                          ),
                          ...state.parsedData.entries.map(
                            (e) => ElementRow(label: e.key, value: e.value),
                          ),
                          if (state.queryParameters.entries.isNotEmpty) ...[
                            SectionHeader(
                              title:
                                  context.l10n?.common_text_queryString ?? '',
                            ),
                            ...state.queryParameters.entries.map(
                              (e) => ElementRow(label: e.key, value: e.value),
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
