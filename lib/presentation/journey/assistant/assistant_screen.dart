import 'package:ai_deeplink_tester/presentation/widget/x_assistant_text_field.dart';
import 'package:ai_deeplink_tester/presentation/widget/x_state_widget.dart';
import 'package:flutter/material.dart';

import '../../../extensions/qr_scan_extension.dart';
import '../../../extensions/context_extensions.dart';

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
              context.scanQrCodeToController(_controller);
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
}
