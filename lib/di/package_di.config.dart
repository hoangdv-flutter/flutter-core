// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_core/data/shared/premium_holder.dart' as _i6;
import 'package:flutter_core/di/app_module.dart' as _i7;
import 'package:flutter_core/util/conectivity/net_work_checker.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:package_info_plus/package_info_plus.dart' as _i4;
import 'package:shared_preferences/shared_preferences.dart' as _i5;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    gh.singleton<_i3.NetWorkChecker>(
      () => _i3.NetWorkChecker(),
      dispose: (i) => i.dispose(),
    );
    await gh.singletonAsync<_i4.PackageInfo>(
      () => appModule.packageInfo,
      preResolve: true,
    );
    await gh.singletonAsync<_i5.SharedPreferences>(
      () => appModule.sharedPref,
      preResolve: true,
    );
    gh.singleton<_i6.PremiumHolder>(
      () => _i6.PremiumHolder(gh<_i5.SharedPreferences>()),
      dispose: (i) => i.disposed(),
    );
    return this;
  }
}

class _$AppModule extends _i7.AppModule {}
