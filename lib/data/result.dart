// TODO Implement this library.
import 'package:flutter_core/core.dart';

class Result<T> {
  final T? data;
  final DataState state;

  Result(this.state, {this.data});
}
