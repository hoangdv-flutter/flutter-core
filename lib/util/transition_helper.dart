part of 'util.dart';

class TransitionHelper {
  static RouteTransitionsBuilder buildSlideTransition(
      {Curve curve = Curves.linear}) {
    return buildRouteTransition((p0, p1) => SlideTransition(
          position: p0,
          child: p1,
        ));
  }

  static RouteTransitionsBuilder buildRouteTransition(
      AnimatedWidget Function(Animation<Offset>, Widget) builder,
      {Curve curve = Curves.linear}) {
    return (context, animation, secondaryAnimation, child) {
      const start = Offset(1.0, 0.0);
      const end = Offset.zero;
      final tween =
          Tween(begin: start, end: end).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(tween);
      return builder(offsetAnimation, child);
    };
  }
}
