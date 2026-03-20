import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../extensions/context_extensions.dart';

class XAssistantTextField extends StatefulWidget {
  const XAssistantTextField({
    super.key,
    required this.onSend,
    required this.inputCodeController,
    required this.isSending,
    this.hintText,
  });

  final TextEditingController inputCodeController;
  final VoidCallback onSend;
  final String? hintText;
  final bool isSending;

  @override
  State<XAssistantTextField> createState() => _XAssistantTextFieldState();
}

class _XAssistantTextFieldState extends State<XAssistantTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: widget.inputCodeController,
              autofocus: false,
              maxLines: 1,
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                labelText: context.l10n?.common_label_yourLink,
                counterText: '',
                border: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: context.textTheme.bodyLarge?.copyWith(
                  color: context.primaryColor.withAlpha(128),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(size: 22, Icons.content_paste),
            onPressed: widget.isSending ? null : _pasteText,
            tooltip: context.l10n?.common_tooltip_paste,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: widget.isSending ? null : widget.onSend,
            tooltip: context.l10n?.common_tooltip_clear,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
        ],
      ),
    );
  }

  Future<void> _pasteText() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null && clipboardData.text != null) {
      setState(() {
        widget.inputCodeController.text = clipboardData.text!;
      });
    }
  }
}
