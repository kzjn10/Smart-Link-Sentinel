import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/base/base_state.dart';
import '../../../data/data_sources/local/app_database.dart';

part 'deeplink_state.freezed.dart';

@freezed
abstract class DeeplinkState with _$DeeplinkState {
  const factory DeeplinkState({
    @Default(ViewState.initial) ViewState viewState,
    @Default([]) List<HistoryEntry> history,
    String? errorMessage,
  }) = _DeeplinkState;
}
