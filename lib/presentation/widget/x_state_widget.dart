import 'package:ai_deeplink_tester/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

abstract class XStateWidget<T extends StatefulWidget> extends State<T> {
  Future<void> showSnackBar(BuildContext context, String? message) async {
    if (message == null || message.isEmpty) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> showErrorSnackBar(BuildContext context, String? message) async {
    if (message == null || message.isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: context.errorColor),
    );
  }
}
