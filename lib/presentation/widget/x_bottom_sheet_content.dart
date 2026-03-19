import 'package:flutter/material.dart';

import '../../extensions/context_extensions.dart';

class XBottomSheetContent extends StatelessWidget {
  const XBottomSheetContent({
    super.key,
    required this.child,
    required this.title,
    this.onDismiss,
    this.height,
    this.padding,
  });

  final Widget child;
  final String? title;
  final double? height;
  final VoidCallback? onDismiss;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: .min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row(
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: Center(
                    child: Text(
                      title ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Padding(
            padding: padding ?? const EdgeInsets.all(8.0),
            child: child,
          ),
        ],
      ),
    );
  }
}
