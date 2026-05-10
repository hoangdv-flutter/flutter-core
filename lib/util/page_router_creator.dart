part of 'util.dart';

class RouterCreator {
  RouterCreator._();

  static Route createRouter(
          {required Function(BuildContext context, Animation<double>? animation,
                  Animation<double>? scondaryAnimation)
              pageBuilder,
          RouteTransitionsBuilder? transitionsBuilder,
          RouteSettings? settings,
          Duration? transitionDuration,
          Duration? reverserDuration}) =>
      Platform.isAndroid
          ? PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  pageBuilder(context, animation, secondaryAnimation),
              settings: settings,
              transitionDuration:
                  transitionDuration ?? const Duration(milliseconds: 200),
              reverseTransitionDuration:
                  reverserDuration ?? const Duration(milliseconds: 200),
              transitionsBuilder:
                  transitionsBuilder ?? TransitionHelper.buildSlideTransition())
          : MaterialPageRoute(
              builder: (context) => pageBuilder(context, null, null),
              settings: settings);
}

class MyRoute extends MaterialPageRoute {
  final Duration duration;

  MyRoute(
      {required super.builder,
      this.duration = const Duration(milliseconds: 300)});

  @override
  Duration get transitionDuration => duration;

  @override
  Duration get reverseTransitionDuration => duration;
}
