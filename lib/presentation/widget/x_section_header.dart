import 'package:flutter/material.dart';

import '../../extensions/context_extensions.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            title ?? '',
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
