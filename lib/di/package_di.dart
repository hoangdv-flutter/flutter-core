import 'package:flutter_core/di/package_di.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@InjectableInit()
Future<void> setupDI(GetIt instance) => instance.init();
