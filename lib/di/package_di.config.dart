// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_core/data/isolate_excutor.dart' as _i3;
import 'package:flutter_core/data/shared/premium_holder.dart' as _i7;
import 'package:flutter_core/di/app_module.dart' as _i8;
import 'package:flutter_core/util/conectivity/net_work_checker.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:package_info_plus/package_info_plus.dart' as _i5;
import 'package:shared_preferences/shared_preferences.dart' as _i6;

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
    gh.factoryAsync<_i3.IsolateExecutor>(() => _i3.IsolateExecutor.create());
    gh.singleton<_i4.NetWorkChecker>(
      _i4.NetWorkChecker(),
      dispose: (i) => i.dispose(),
    );
    await gh.singletonAsync<_i5.PackageInfo>(
      () => appModule.packageInfo,
      preResolve: true,
    );
    await gh.singletonAsync<_i6.SharedPreferences>(
      () => appModule.sharedPref,
      preResolve: true,
    );
    gh.singleton<_i7.PremiumHolder>(
      _i7.PremiumHolder(gh<_i6.SharedPreferences>()),
      dispose: (i) => i.disposed(),
    );
    return this;
  }
}

class _$AppModule extends _i8.AppModule {}
