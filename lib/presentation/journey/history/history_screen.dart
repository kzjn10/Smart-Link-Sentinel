import 'dart:async';

import 'package:ai_deeplink_tester/core/base/base_state.dart';
import 'package:ai_deeplink_tester/domain/models/history_entity.dart';
import 'package:ai_deeplink_tester/extensions/context_extensions.dart';
import 'package:ai_deeplink_tester/presentation/widget/x_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utils/app_logger.dart';
import '../../../di/injection.dart';
import '../../../extensions/datetime_extension.dart';
import 'history_state.dart';
import 'history_view_model.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HistoryViewModel>(),
      child: const _HistoryScreenView(),
    );
  }
}

class _HistoryScreenView extends StatefulWidget {
  const _HistoryScreenView();

  @override
  State<_HistoryScreenView> createState() => _HistoryScreenViewState();
}

class _HistoryScreenViewState extends XStateWidget<_HistoryScreenView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n?.common_text_history ?? ''),
        actions: [
          IconButton(
            onPressed: () {
              context.read<HistoryViewModel>().clearHistory();
            },
            icon: Icon(Icons.clear_all),
            tooltip: context.l10n?.common_tooltip_clearAllHistory,
          ),
        ],
      ),
      body: BlocBuilder<HistoryViewModel, HistoryState>(
        builder: (context, state) {
          if (state.viewState == ViewState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.viewState == ViewState.error) {
            AppLogger.error(state.errorMessage ?? '');
            return Center(
              child: SelectableText('Error: ${state.errorMessage}'),
            );
          }

          final historyList = state.history;
          if (historyList.isEmpty) {
            return const Center(child: Text('No history yet.'));
          }

          return ListView.separated(
            itemCount: historyList.length,
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return _HistoryRow(
                history: historyList[index],
                onOpenLink: (link) async {
                  context.read<HistoryViewModel>().addOrUpdateHistory(link);
                  unawaited(_launchUrl(link));
                },
                onCopyLink: (link) {
                  unawaited(_copyLinkToClipboard(link));
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _launchUrl(String resourceIdentifier) async {
    try {
      if (!await launchUrl(Uri.parse(resourceIdentifier))) {
        throw Exception('Could not launch $resourceIdentifier');
      }
    } catch (e) {
      AppLogger.error(e.toString());
      if (mounted) {
        showErrorSnackBar(
          context,
          context.l10n?.common_message_noAppFoundToHandleDeepLink,
        );
      }
    }
  }

  Future<void> _copyLinkToClipboard(String link) async {
    await Clipboard.setData(ClipboardData(text: link));
    if (mounted) {
      showSnackBar(context, context.l10n?.common_message_copiedToClipboard);
    }
  }
}

// ─────────────────────────────────────────────
// Element row
// ─────────────────────────────────────────────
class _HistoryRow extends StatelessWidget {
  const _HistoryRow({
    required this.history,
    required this.onOpenLink,
    required this.onCopyLink,
  });

  final HistoryEntity history;
  final Function(String) onOpenLink;
  final Function(String) onCopyLink;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: context.secondaryContainer,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.primaryColor.withAlpha(20)),
        ),
        child: InkWell(
          onTap: () async {
            onOpenLink(history.link);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        history.link,
                        style: context.textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        history.updatedAt.formatDateTime(),
                        style: context.textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    history.isFavorite
                        ? Icons.stars_sharp
                        : Icons.star_outline_sharp,
                    color: history.isFavorite
                        ? context.primaryColor
                        : Colors.black87,
                  ),
                  onPressed: () {
                    context.read<HistoryViewModel>().toggleFavorite(history);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.black87),
                  onPressed: () {
                    context.read<HistoryViewModel>().deleteHistory(history.id);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.copy, color: Colors.black87),
                  onPressed: () {
                    onCopyLink(history.link);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
