import 'package:ai_deeplink_tester/domain/usecases/analyze_link_usecase.dart';
import 'package:injectable/injectable.dart';

import '../../../core/base/base_state.dart';
import '../../../core/base/base_view_model.dart';
import 'assistant_state.dart';

@injectable
class AssistantViewModel extends BaseViewModel<AssistantState> {
  final AnalyzeLinkUseCase _analyzeLinkUseCase;

  AssistantViewModel(this._analyzeLinkUseCase) : super(const AssistantState());

  Future<void> analyzeLink(String link) async {
    try {
      emit(state.copyWith(viewState: ViewState.loading));
      final result = await _analyzeLinkUseCase.execute(link);
      emit(state.copyWith(viewState: ViewState.loaded));
    } catch (e) {
      emit(
        state.copyWith(viewState: ViewState.error, errorMessage: e.toString()),
      );
    }
  }
}
