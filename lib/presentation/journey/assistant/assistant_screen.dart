import 'package:ai_deeplink_tester/presentation/widget/x_assistant_text_field.dart';
import 'package:ai_deeplink_tester/presentation/widget/x_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../extensions/context_extensions.dart';
import '../../widget/x_bottom_sheet_content.dart';

class AssistantScreen extends StatelessWidget {
  const AssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _AssistantScreenView();
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
  bool _isSending = false;

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

  Future<void> _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSending) return;

    _controller.clear();
    setState(() => _isSending = true);

    _scrollToBottom();
    // await context.read<ChatProvider>().sendMessage(text);
    _scrollToBottom();

    setState(() => _isSending = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n?.common_text_assistant ?? ''),
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
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.tertiaryFixedDimColor.withAlpha(100),
                borderRadius: BorderRadius.circular(12),
              ),
              child: XAssistantTextField(
                inputCodeController: _controller,
                hintText: context.l10n?.common_hint_deeplink,
                onSend: _handleSend,
              ),
            ),
            // Messages
            Expanded(
              child: Center(child: Text('Assistant')),
              // child: Consumer<ChatProvider>(
              //   builder: (context, chat, _) {
              //     _scrollToBottom();
              //     return ListView.builder(
              //       controller: _scrollController,
              //       padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              //       itemCount: chat.messages.length,
              //       itemBuilder: (context, index) {
              //         return ChatBubble(message: chat.messages[index]);
              //       },
              //     );
              //   },
              // ),
            ),
          ],
        ),
      ),
    );
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
                        _controller.text = value;
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
