import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../core/base/base_state.dart';
import '../../../core/base/base_view_model.dart';
import '../../../domain/models/history_entity.dart';
import '../../../domain/repositories/history_repository.dart';
import 'history_state.dart';

@injectable
class HistoryViewModel extends BaseViewModel<HistoryState> {
  final HistoryRepository _historyRepository;
  StreamSubscription? _historySubscription;

  HistoryViewModel(this._historyRepository) : super(const HistoryState()) {
    _loadHistory();
  }

  void _loadHistory() {
    emit(state.copyWith(viewState: ViewState.loading));
    _historySubscription = _historyRepository.watchHistory().listen(
      (history) {
        emit(state.copyWith(viewState: ViewState.loaded, history: history));
      },
      onError: (error) {
        emit(
          state.copyWith(
            viewState: ViewState.error,
            errorMessage: error.toString(),
          ),
        );
      },
    );
  }

  Future<void> addOrUpdateHistory(String link) async {
    unawaited(_historyRepository.addHistory(link));
  }

  void deleteHistory(String id) {
    _historyRepository.deleteHistory(id);
  }

  void clearHistory() {
    _historyRepository.clearHistory();
  }

  void toggleFavorite(HistoryEntity entry) {
    _historyRepository.toggleFavorite(entry);
  }

  @override
  Future<void> close() {
    _historySubscription?.cancel();
    return super.close();
  }
}
