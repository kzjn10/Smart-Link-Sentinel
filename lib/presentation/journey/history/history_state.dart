import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/base/base_state.dart';
import '../../../domain/models/history_entity.dart';

part 'history_state.freezed.dart';

@freezed
abstract class HistoryState with _$HistoryState {
  const factory HistoryState({
    @Default(ViewState.initial) ViewState viewState,
    @Default([]) List<HistoryEntity> history,
    String? errorMessage,
  }) = _HistoryState;
}
