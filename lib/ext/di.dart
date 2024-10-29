part of 'exts.dart';


T appInject<T extends Object>() => GetIt.I<T>();

Future<T> appInjectAsync<T extends Object>() => GetIt.I.getAsync<T>();
