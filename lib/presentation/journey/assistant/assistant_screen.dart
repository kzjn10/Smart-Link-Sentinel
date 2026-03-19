import 'package:ai_deeplink_tester/presentation/widget/x_state_widget.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Assistant',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
