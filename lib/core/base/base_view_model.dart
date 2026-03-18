import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseViewModel<S> extends Cubit<S> {
  BaseViewModel(super.initialState);

  bool _isDisposed = false;

  @override
  void emit(S state) {
    if (!_isDisposed) {
      super.emit(state);
    }
  }

  @override
  Future<void> close() {
    _isDisposed = true;
    return super.close();
  }
}
