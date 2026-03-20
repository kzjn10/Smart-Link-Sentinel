import 'package:ai_deeplink_tester/domain/usecases/analyze_link_usecase.dart';
import 'package:injectable/injectable.dart';

import '../../../core/base/base_view_model.dart';
import 'assistant_state.dart';

@injectable
class AssistantViewModel extends BaseViewModel<AssistantState> {
  final AnalyzeLinkUseCase _analyzeLinkUseCase;

  AssistantViewModel(this._analyzeLinkUseCase) : super(const AssistantState());

  Future<void> analyzeLink(String link) async {
    try {
      if (link.isEmpty || state.isSending) return;
      emit(
        state.copyWith(
          isSending: true,
          viewState: .loading,
          errorMessage: null,
          finalUrl: null,
          status: null,
          detectedParams: const {},
          securityWarning: null,
          suggestion: null,
        ),
      );
      final result = await _analyzeLinkUseCase.execute(link);
      emit(
        state.copyWith(
          isSending: false,
          viewState: .loaded,
          finalUrl: result.finalUrl,
          status: result.status,
          detectedParams: result.detectedParams,
          securityWarning: result.securityWarning,
          suggestion: result.suggestion,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSending: false,
          viewState: .error,
          errorMessage: e.toString(),
          finalUrl: null,
          status: null,
          detectedParams: const {},
          securityWarning: null,
          suggestion: null,
        ),
      );
    }
  }
}
