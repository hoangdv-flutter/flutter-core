import 'package:flutter_core/data/response.dart';

Future<Response<T>> process<T>(Future<T> Function() onProcess) async {
  try {
    return Response.success(await onProcess());
  } catch (e) {
    return Response.failed(e);
  }
}
