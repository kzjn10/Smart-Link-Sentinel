import 'package:flutter/material.dart';

import '../../extensions/context_extensions.dart';

class ElementRow extends StatelessWidget {
  const ElementRow({super.key, required this.label, required this.value});

  final String? label;
  final String? value;

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
              label ?? '',
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: SelectableText(
              value ?? '',
              style: context.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
