import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/base/base_state.dart';
import '../../../core/utils/app_logger.dart';
import '../../../di/injection.dart';
import '../../../extensions/context_extensions.dart';
import '../../widget/x_bottom_sheet_content.dart';
import '../../widget/x_input_link_text_field.dart';
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
              _scanQrCode();
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

  Future<void> _scanQrCode() async {
    await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: .vertical(top: .circular(20)),
      ),
      builder: (_) => _buildScanQrCodeBottomSheetContent(context),
    );
  }

  Widget _buildScanQrCodeBottomSheetContent(BuildContext sheetContext) {
    final mobileScannerController = MobileScannerController();
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: XBottomSheetContent(
        padding: EdgeInsets.zero,
        height: context.deviceHeight * 0.5,
        title: context.l10n?.common_text_scanQrCodeTitle,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                width: 300,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: MobileScanner(
                    controller: mobileScannerController,
                    onDetect: (capture) {
                      final barcode = capture.barcodes.firstOrNull;
                      final value = barcode?.rawValue;
                      if (value != null && value.isNotEmpty) {
                        _linkController.text = value;
                        mobileScannerController.dispose();
                        Navigator.pop(sheetContext);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(context.l10n?.common_text_scanQrCode ?? ''),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  mobileScannerController.dispose();
                  Navigator.pop(sheetContext);
                },
                child: Text(context.l10n?.common_text_cancel ?? ''),
              ),
            ],
          ),
        ),
      ),
    );
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
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
