import 'package:flutter/cupertino.dart';
import 'package:flutter_core/core.dart';

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

abstract class LifecycleStateWatcher<W extends StatefulWidget>
    extends BaseState<W> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @mustCallSuper
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      case AppLifecycleState.inactive:
        onPaused();
        break;
      case AppLifecycleState.paused:
        onInactive();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  void onResumed() {}

  void onPaused() {}

  void onInactive() {}

  void onDetached() {}

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
