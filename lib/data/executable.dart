abstract class Executable {
  var _isBusy = false;

  Future<T> executeTask<T>(Future<T> Function() onProcess) async {
    return await onProcess();
  }

  Future<T?> executeSingleTask<T>(Future<T> Function() onProcess) async {
    if (_isBusy) return null;
    _isBusy = true;
    final value = await onProcess();
    _isBusy = false;
    return value;
  }

  void dispose() {}
}
