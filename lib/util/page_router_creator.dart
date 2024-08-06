part of 'util.dart';

class RouterCreator {
  RouterCreator._();

  static createRouter(
          {required RoutePageBuilder pageBuilder,
          RouteTransitionsBuilder? transitionsBuilder,
          RouteSettings? settings,
          Duration? transitionDuration,
          Duration? reverserDuration}) =>
      PageRouteBuilder(
          pageBuilder: pageBuilder,
          settings: settings,
          transitionDuration:
              transitionDuration ?? const Duration(milliseconds: 200),
          reverseTransitionDuration:
              reverserDuration ?? const Duration(milliseconds: 200),
          transitionsBuilder:
              transitionsBuilder ?? TransitionHelper.buildSlideTransition());
}
