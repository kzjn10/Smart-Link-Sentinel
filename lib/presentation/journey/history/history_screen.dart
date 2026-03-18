import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../di/injection.dart';
import 'history_state.dart';
import 'history_view_model.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<HistoryViewModel>(),
      child: Scaffold(
        body: BlocBuilder<HistoryViewModel, HistoryState>(
          builder: (context, state) {
            if (state.viewState == .loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.viewState == .error) {
              return Center(child: Text('Error: ${state.errorMessage}'));
            }

            final historyList = state.history;
            if (historyList.isEmpty) {
              return const Center(child: Text('No history yet.'));
            }

            return ListView.builder(
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final item = historyList[index];
                return ListTile(
                  title: Text(item.link),
                  subtitle: Text(item.updatedAt.toString()),
                  trailing: Row(
                    mainAxisSize: .min,
                    children: [
                      IconButton(
                        icon: Icon(
                          item.isFavorite ? Icons.star : Icons.star_border,
                          color: item.isFavorite ? Colors.amber : Colors.grey,
                        ),
                        onPressed: () {
                          context.read<HistoryViewModel>().toggleFavorite(item);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context.read<HistoryViewModel>().deleteHistory(
                            item.id,
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
