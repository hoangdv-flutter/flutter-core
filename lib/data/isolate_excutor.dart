import 'dart:async';
import 'dart:isolate';

import 'package:injectable/injectable.dart';
import 'package:flutter_core/ext/app.dart';

@injectable
class IsolateExecutor {
  final ReceivePort mainPort;

  final SendPort isolatePort;

  final Isolate isolate;

  IsolateExecutor(
      {required this.isolatePort,
      required this.isolate,
      required this.mainPort});

  static void _process(SendPort mainPort) {
    final isolatePort = ReceivePort();
    mainPort.send(isolatePort.sendPort);
    isolatePort.listen((message) async {
      if (message is Execution) {
        final pr = await process(
            () async => await message.onExecutor.call(message.params));
        message.value = pr.value;
        mainPort.send(message);
      }
    });
  }

  @factoryMethod
  static Future<IsolateExecutor> create() async {
    final mainPort = ReceivePort();
    final isolate = await Isolate.spawn(_process, mainPort.sendPort);
    final Completer<IsolateExecutor> completer = Completer();
    mainPort.listen((message) {
      if (message is Execution) {
        message.onDone?.call(message.value);
      } else if (message is SendPort) {
        completer.complete(IsolateExecutor(
            isolate: isolate, mainPort: mainPort, isolatePort: message));
      }
    });
    return completer.future;
  }

  Future<V?> execute<V>(
      {required Future<V> Function(List<dynamic>? params) onExecute,
      List<dynamic>? params}) {
    final completer = Completer<V>();
    isolatePort.send(Execution(
      onExecutor: onExecute,
      params: params,
      onDone: (v) => completer.complete(v),
    ));
    return completer.future;
  }

  void dispose() {
    mainPort.close();
    isolate.kill(priority: Isolate.immediate);
  }
}

class Execution<V> {
  final List<dynamic>? params;

  final Future<V> Function(List<dynamic>? params) onExecutor;

  final Function(V value)? onDone;

  V? value;

  Execution({required this.onExecutor, this.onDone, this.params});
}
