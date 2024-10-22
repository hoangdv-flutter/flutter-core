part of '../util.dart';

class GlobalStateManager {
  static void updateCurrentScreenContext(GlobalKey<NavigatorState> key) {
    _navigatorState = WeakReference(key);
  }

  static WeakReference<GlobalKey<NavigatorState>>? _navigatorState;

  static GlobalKey<NavigatorState>? get navigationKey =>
      _navigatorState?.target;

  GlobalStateManager._();
}
