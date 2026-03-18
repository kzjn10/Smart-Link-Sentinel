import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/base/base_state.dart';
import '../../../data/data_sources/local/app_database.dart';

part 'history_state.freezed.dart';

@freezed
abstract class HistoryState with _$HistoryState {
  const factory HistoryState({
    @Default(ViewState.initial) ViewState viewState,
    @Default([]) List<HistoryEntry> history,
    String? errorMessage,
  }) = _HistoryState;
}
