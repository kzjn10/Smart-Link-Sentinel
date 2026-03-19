import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../extensions/context_extensions.dart';

class XInputKeyTextField extends StatefulWidget {
  const XInputKeyTextField({
    super.key,
    required this.controller,
    this.obscureText = true,
    this.labelText,
    this.hintText,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final bool? obscureText;

  @override
  State<XInputKeyTextField> createState() => _XInputKeyTextFieldState();
}

class _XInputKeyTextFieldState extends State<XInputKeyTextField> {
  final _onClearValueNotifier = ValueNotifier(false);

  @override
  void initState() {
    _onClearValueNotifier.value = widget.controller.text.isNotEmpty;
    widget.controller.addListener(() {
      _onClearValueNotifier.value = widget.controller.text.isNotEmpty;
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
              controller: widget.controller,
              autofocus: false,
              obscureText: widget.obscureText ?? true,
              maxLines: 1,
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                labelText: widget.labelText,
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
                        widget.controller.clear();
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
        widget.controller.text = clipboardData.text!;
      });
    }
  }
}
