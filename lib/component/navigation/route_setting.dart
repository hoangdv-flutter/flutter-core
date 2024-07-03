import 'package:go_router/go_router.dart';

class RouteSetting<T extends Object> {
  final GoRoute route;
  final T? extras;

  RouteSetting(this.route, {this.extras});
}
