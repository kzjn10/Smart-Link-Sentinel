import 'package:ai_deeplink_tester/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/base/base_state.dart';
import '../../../extensions/context_extensions.dart';
import '../../../extensions/qr_scan_extension.dart';
import '../../../extensions/string_extensions.dart';
import '../../widget/widget.dart';
import 'assistant_state.dart';
import 'assistant_view_model.dart';

class AssistantScreen extends StatelessWidget {
  const AssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AssistantViewModel>(),
      child: const _AssistantScreenView(),
    );
  }
}

class _AssistantScreenView extends StatefulWidget {
  const _AssistantScreenView();

  @override
  State<_AssistantScreenView> createState() => _AssistantScreenViewState();
}

class _AssistantScreenViewState extends XStateWidget<_AssistantScreenView> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _submitLinkForAnalysis() async {
    await context.read<AssistantViewModel>().analyzeLink(_controller.text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AssistantViewModel, AssistantState>(
      listener: (context, state) async {
        if (state.viewState == ViewState.error) {
          await showErrorSnackBar(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(context.l10n?.common_text_assistant ?? ''),
            actions: [
              IconButton(
                onPressed: () {
                  context.scanQrCodeToController(_controller);
                },
                icon: const Icon(Icons.qr_code_scanner),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: context.tertiaryFixedDimColor.withAlpha(100),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: XAssistantTextField(
                    inputCodeController: _controller,
                    hintText: context.l10n?.common_hint_deeplink,
                    onSend: _submitLinkForAnalysis,
                    isSending: state.isSending,
                  ),
                ),
                // Response
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    children: [
                      if (state.viewState == ViewState.initial)
                        const SizedBox(
                          height: 24,
                          child: Text('Send a deep link above to analyze it.'),
                        ),
                      if (state.viewState == ViewState.loading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: _AssistantResultShimmer(),
                        ),
                      if (state.viewState == ViewState.loaded) ...[
                        _AssistantResultCard(
                          finalUrl: state.finalUrl,
                          status: state.status,
                          detectedParams: state.detectedParams,
                          securityWarning: state.securityWarning,
                          suggestion: state.suggestion,
                        ),
                      ],

                      if (state.viewState == ViewState.error)
                        Padding(
                          padding: const .symmetric(vertical: 20),
                          child: Text(
                            state.errorMessage ??
                                context
                                    .l10n
                                    ?.common_message_failedToAnalyzeDeepLink ??
                                '',
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: context.errorColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// Assistant result card
// ─────────────────────────────────────────────
class _AssistantResultCard extends StatelessWidget {
  const _AssistantResultCard({
    required this.finalUrl,
    required this.status,
    required this.detectedParams,
    required this.securityWarning,
    required this.suggestion,
  });

  final String? finalUrl;
  final String? status;
  final Map<String, String> detectedParams;
  final String? securityWarning;
  final String? suggestion;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: .circular(12),
        border: Border.all(color: context.primaryColor.withAlpha(100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: context.l10n?.common_text_generatedDeepLink),
          if (finalUrl != null && finalUrl!.isNotEmpty) ...[
            ElementRow(label: context.l10n?.common_text_data, value: finalUrl),
          ],
          ElementRow(label: context.l10n?.common_text_status, value: status),
          if (detectedParams.isNotEmpty) ...[
            SectionHeader(title: context.l10n?.common_text_detectedParams),
            ...detectedParams.entries.map(
              (e) => ElementRow(label: e.key, value: e.value),
            ),
          ],
          if (securityWarning != null && securityWarning!.isNotEmpty) ...[
            SectionHeader(title: context.l10n?.common_text_securityWarning),
            Text(
              securityWarning!,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.errorColor,
              ),
            ),
          ],
          if (suggestion != null && suggestion!.isNotEmpty) ...[
            SectionHeader(title: context.l10n?.common_text_suggestion),
            Text(suggestion.orEmpty, style: context.textTheme.bodyMedium),
          ],
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Assistant result shimmer
// ─────────────────────────────────────────────
class _AssistantResultShimmer extends StatelessWidget {
  const _AssistantResultShimmer();

  @override
  Widget build(BuildContext context) {
    final baseColor = context.tertiaryFixedDimColor.withAlpha(110);
    final highlightColor = context.tertiaryFixedDimColor.withAlpha(45);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.primaryColor.withAlpha(120)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _ShimmerLine(width: 150, height: 16),
            SizedBox(height: 10),
            _ShimmerLine(width: double.infinity, height: 14),
            SizedBox(height: 8),
            _ShimmerLine(width: 220, height: 14),
            SizedBox(height: 14),
            _ShimmerLine(width: 120, height: 14),
            SizedBox(height: 8),
            _ShimmerLine(width: double.infinity, height: 12),
            SizedBox(height: 6),
            _ShimmerLine(width: 280, height: 12),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Shimmer line
// ─────────────────────────────────────────────
class _ShimmerLine extends StatelessWidget {
  const _ShimmerLine({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
