part of 'presenter.dart';

abstract class BaseCubit<T> extends Cubit<T> {
  BaseCubit(super.initialState);

  T? dataOrNull;

  var _isBusy = false;

  @protected
  Future<S?> runTask<S>(Future<S?> Function() process) async {
    return await process();
  }

  @mustCallSuper
  @override
  void emit(T state) {
    if (isClosed) return;
    dataOrNull = state;
    super.emit(state);
  }

  @override
  Future<void> close() {
    debugPrint("close cubit $runtimeType");
    return super.close();
  }

  @protected
  Future<S?> runBlockTask<S>(Future<S?> Function() process) async {
    if (_isBusy) return null;
    _isBusy = true;
    final v = await process();
    _isBusy = false;
    return v;
  }
}
