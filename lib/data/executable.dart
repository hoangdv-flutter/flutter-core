abstract class Executable {
  var _isBusy = false;

  Future<T?> executeTask<T>(Future<T> Function() onProcess) async {
    return await runCatchingAsync(onProcess);
  }

  Future<T?> executeSingleTask<T>(Future<T> Function() onProcess) async {
    if (_isBusy) return null;
    _isBusy = true;
    final value = await runCatchingAsync(() => onProcess());
    _isBusy = false;
    return value;
  }

  Future<void> dispose() async {}
}

T? runCatching<T>(T Function() execute) {
  try {
    return execute();
  } catch (_) {}
  return null;
}

Future<T?> runCatchingAsync<T>(Future<T> Function() execute) async {
  try {
    return await execute();
  } catch (_) {}
  return null;
}
