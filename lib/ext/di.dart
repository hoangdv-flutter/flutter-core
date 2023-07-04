import 'package:get_it/get_it.dart';

T appInject<T extends Object>() => GetIt.I<T>();

Future<T> appInjectAsync<T extends Object>() => GetIt.I.getAsync<T>();
