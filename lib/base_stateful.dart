import 'package:flutter/cupertino.dart';
import 'package:flutter_core/util/crash_log.dart';

abstract class BaseState<W extends StatefulWidget> extends State<W> {
  @override
  void setState(VoidCallback fn) {
    CrashlyticsLogger.logError("setState from ${runtimeType.toString()}");
    try {
      if (!context.mounted || !mounted) return;
      super.setState(fn);
    } catch (e) {}
  }
}
