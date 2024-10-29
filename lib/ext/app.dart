part of 'exts.dart';

Future<Response<T>> process<T>(Future<T> Function() onProcess) async {
  try {
    return Response.success(await onProcess());
  } catch (e) {
    return Response.failed(e);
  }
}

T? runCatching<T>(T Function() execute, {Function(Object)? onError}) {
  try {
    return execute.call();
  } catch (e) {
    onError?.call(e);
  }
  return null;
}

Future<T?> runCatchingAsync<T>(Future<T> Function() execute,
    {Function(Object)? onError}) async {
  try {
    return await execute.call();
  } catch (e) {
    onError?.call(e);
  }
  return null;
}
