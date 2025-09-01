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

import '../../data/data_sources/remote/auth_remote_data_source.dart' as _i865;
import '../../data/data_sources/remote/impl/auth_remote_data_source_impl.dart'
    as _i335;
import '../../data/repos/auth/auth_repo_impl.dart' as _i291;
import '../../domain/repos/auth/auth_repo.dart' as _i876;
import '../../domain/use_cases/auth/auth_use_case.dart' as _i285;
import '../../features/auth/presentation/cubit/auth_view_model.dart' as _i745;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i865.AuthRemoteDataSource>(
      () => _i335.AuthRemoteDataSourceImpl(),
    );
    gh.factory<_i876.AuthRepo>(
      () => _i291.AuthRepoImpl(gh<_i865.AuthRemoteDataSource>()),
    );
    gh.factory<_i285.AuthUseCase>(
      () => _i285.AuthUseCase(gh<_i876.AuthRepo>()),
    );
    gh.factory<_i745.AuthViewModel>(
      () => _i745.AuthViewModel(authUseCase: gh<_i285.AuthUseCase>()),
    );
    return this;
  }
}
