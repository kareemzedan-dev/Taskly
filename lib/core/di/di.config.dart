// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import '../../data/data_sources/remote/auth_remote_data_source.dart' as _i865;
import '../../data/data_sources/remote/impl/auth_remote_data_source_impl.dart'
    as _i335;
import '../../data/repos/auth/auth_repo_impl.dart' as _i291;
import '../../domain/repos/auth/auth_repo.dart' as _i876;
import '../../domain/use_cases/auth/auth_use_case.dart' as _i285;
import '../../features/auth/presentation/cubit/auth_view_model.dart' as _i745;
import '../../features/client/data/data_sources/remote/home_remote_data_source.dart'
    as _i307;
import '../../features/client/data/data_sources/remote/impl/home_remote_data_source_impl.dart'
    as _i922;
import '../../features/client/data/repos/home/home_repo_impl.dart' as _i86;
import '../../features/client/domain/repos/home/home_repos.dart' as _i660;
import '../../features/client/domain/use_cases/home/home_use_case.dart'
    as _i213;
import '../../features/client/presentation/cubit/user_view_model/user_info_view_model.dart'
    as _i907;
import '../../features/client/presentation/views/tabs/home/presentation/cubit/order_view_model/order_view_model.dart'
    as _i791;
import '../../features/client/presentation/views/tabs/home/presentation/cubit/services_view_model/services_view_model.dart'
    as _i313;
import '../services/supabase_service.dart' as _i374;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.singleton<_i374.SupabaseService>(() => _i374.SupabaseService());
    gh.factory<_i865.AuthRemoteDataSource>(
      () => _i335.AuthRemoteDataSourceImpl(),
    );
    gh.factory<_i876.AuthRepo>(
      () => _i291.AuthRepoImpl(gh<_i865.AuthRemoteDataSource>()),
    );
    gh.factory<_i285.AuthUseCase>(
      () => _i285.AuthUseCase(gh<_i876.AuthRepo>()),
    );
    gh.factory<_i307.HomeRemoteDataSource>(
      () =>
          _i922.HomeRemoteDataSourceImpl(supabase: gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i745.AuthViewModel>(
      () => _i745.AuthViewModel(authUseCase: gh<_i285.AuthUseCase>()),
    );
    gh.factory<_i660.HomeRepos>(
      () => _i86.HomeRepoImpl(
        homeremoteDataSource: gh<_i307.HomeRemoteDataSource>(),
      ),
    );
    gh.factory<_i213.HomeUseCase>(
      () => _i213.HomeUseCase(gh<_i660.HomeRepos>()),
    );
    gh.factory<_i907.UserInfoViewModel>(
      () => _i907.UserInfoViewModel(gh<_i213.HomeUseCase>()),
    );
    gh.factory<_i791.OrderViewModel>(
      () => _i791.OrderViewModel(gh<_i213.HomeUseCase>()),
    );
    gh.factory<_i313.ServicesViewModel>(
      () => _i313.ServicesViewModel(gh<_i213.HomeUseCase>()),
    );
    return this;
  }
}
