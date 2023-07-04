import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class AppModule {
  @singleton
  @preResolve
  Future<SharedPreferences> get sharedPref async =>
      await SharedPreferences.getInstance();

  @singleton
  @preResolve
  Future<PackageInfo> get packageInfo async =>
      (await PackageInfo.fromPlatform());
}