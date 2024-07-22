// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_core/data/shared/premium_holder.dart' as _i932;
import 'package:flutter_core/di/app_module.dart' as _i79;
import 'package:flutter_core/util/util.dart' as _i763;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:package_info_plus/package_info_plus.dart' as _i655;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => appModule.sharedPref,
      preResolve: true,
    );
    await gh.singletonAsync<_i655.PackageInfo>(
      () => appModule.packageInfo,
      preResolve: true,
    );
    gh.singleton<_i763.NetWorkChecker>(
      () => _i763.NetWorkChecker(),
      dispose: (i) => i.dispose(),
    );
    gh.singleton<_i932.PremiumHolder>(
      () => _i932.PremiumHolder(gh<_i460.SharedPreferences>()),
      dispose: (i) => i.disposed(),
    );
    return this;
  }
}

class _$AppModule extends _i79.AppModule {}
