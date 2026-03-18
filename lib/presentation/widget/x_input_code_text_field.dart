import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../extensions/context_extensions.dart';

class XDeeplinkTextField extends StatefulWidget {
  const XDeeplinkTextField({
    super.key,
    required this.inputCodeController,
    this.hintText,
    this.onScan,
  });

  final TextEditingController inputCodeController;
  final VoidCallback? onScan;
  final String? hintText;

  @override
  State<XDeeplinkTextField> createState() => _XDeeplinkTextFieldState();
}

class _XDeeplinkTextFieldState extends State<XDeeplinkTextField> {
  final _onClearValueNotifier = ValueNotifier(false);

  @override
  void initState() {
    widget.inputCodeController.addListener(() {
      _onClearValueNotifier.value = widget.inputCodeController.text.isNotEmpty;
    });
    super.initState();
  }

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
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: widget.onScan,
            tooltip: context.l10n?.common_tooltip_scanQrCode,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          IconButton(
            icon: const Icon(Icons.content_paste),
            onPressed: _pasteText,
            tooltip: context.l10n?.common_tooltip_paste,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          AnimatedBuilder(
            animation: _onClearValueNotifier,
            builder: (_, _) {
              return IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: _onClearValueNotifier.value
                    ? () {
                        widget.inputCodeController.clear();
                        _onClearValueNotifier.value = false;
                      }
                    : null,
                tooltip: context.l10n?.common_tooltip_clear,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              );
            },
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
