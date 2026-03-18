import 'package:flutter/material.dart';

import '../../../di/injection.dart';
import '../../../extensions/context_extensions.dart';
import '../../widget/x_input_code_text_field.dart';
import 'deeplink_view_model.dart';

class DeeplinkScreen extends StatefulWidget {
  const DeeplinkScreen({super.key});

  @override
  State<DeeplinkScreen> createState() => _DeeplinkScreenState();
}

class _DeeplinkScreenState extends State<DeeplinkScreen> {
  final TextEditingController _deeplinkController = TextEditingController();
  final _deeplinkViewModel = getIt<DeeplinkViewModel>();

  @override
  void initState() {
    super.initState();
    _deeplinkController.addListener(() {
      _deeplinkViewModel.onLinkChanged(_deeplinkController.text);
    });
  }

  @override
  void dispose() {
    _deeplinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deeplink')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: .min,
          spacing: 12,
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.tertiaryFixedDimColor.withAlpha(100),
                borderRadius: .circular(12),
              ),
              child: XDeeplinkTextField(
                inputCodeController: _deeplinkController,
                hintText: 'myDeepLink://',
              ),
            ),
            FilledButton(
              onPressed: () {},
              child: Text(context.l10n?.common_text_openDeeplink ?? ''),
            ),
            AnimatedContainer(
              decoration: BoxDecoration(
                color: context.tertiaryFixedDimColor.withAlpha(100),
                borderRadius: .circular(12),
              ),
              duration: const Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              child: XDeeplinkTextField(
                inputCodeController: _deeplinkController,
                hintText: 'myDeepLink://',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
