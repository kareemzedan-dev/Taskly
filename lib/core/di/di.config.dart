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
import '../../data/data_sources/remote/impl/orders_remote_data_source_impl.dart'
    as _i607;
import '../../data/data_sources/remote/orders_remote_data_source.dart' as _i700;
import '../../data/repos/auth/auth_repo_impl.dart' as _i291;
import '../../data/repos/orders/orders_repo_impl.dart' as _i879;
import '../../domain/repos/auth/auth_repo.dart' as _i876;
import '../../domain/repos/orders/orders_repo.dart' as _i145;
import '../../domain/use_cases/auth/auth_use_case.dart' as _i285;
import '../../domain/use_cases/orders/orders_use_case.dart' as _i340;
import '../../features/auth/presentation/cubit/auth_view_model.dart' as _i745;
import '../../features/client/data/data_sources/remote/home_remote_data_source.dart'
    as _i307;
import '../../features/client/data/data_sources/remote/impl/home_remote_data_source_impl.dart'
    as _i922;
import '../../features/client/data/repos/home/home_repo_impl.dart' as _i86;
import '../../features/client/domain/repos/home/home_repos.dart' as _i660;
import '../../features/client/domain/use_cases/home/home_use_case.dart'
    as _i213;
import '../../features/client/presentation/cubit/client_info_view_model/client_info_view_model.dart'
    as _i449;
import '../../features/client/presentation/views/tabs/home/presentation/cubit/freelancers_view_model/freelancers_view_model.dart'
    as _i392;
import '../../features/client/presentation/views/tabs/home/presentation/cubit/place_order_view_model/place_order_view_model.dart'
    as _i399;
import '../../features/client/presentation/views/tabs/home/presentation/cubit/services_view_model/services_view_model.dart'
    as _i313;
import '../../features/client/presentation/views/tabs/my_jobs/presentation/cubit/get_order_view_model.dart/get_order_view_model.dart'
    as _i772;
import '../../features/freelancer/presentation/cubit/freelancer_info_view_model/freelancer_info_view_model.dart'
    as _i776;
import '../services/file_uploaded_services.dart' as _i383;
import '../services/supabase_service.dart' as _i374;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.singleton<_i383.FilePickerService>(() => _i383.FilePickerService());
    gh.singleton<_i374.SupabaseService>(() => _i374.SupabaseService());
    gh.factory<_i865.AuthRemoteDataSource>(
      () => _i335.AuthRemoteDataSourceImpl(),
    );
    gh.factory<_i700.OrdersRemoteDataSource>(
      () => _i607.OrdersRemoteDataSourceImpl(),
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
    gh.factory<_i145.OrdersRepo>(
      () => _i879.OrdersRepoImpl(
        ordersRemoteDataSource: gh<_i700.OrdersRemoteDataSource>(),
      ),
    );
    gh.factory<_i660.HomeRepos>(
      () => _i86.HomeRepoImpl(
        homeremoteDataSource: gh<_i307.HomeRemoteDataSource>(),
      ),
    );
    gh.factory<_i340.OrdersUseCase>(
      () => _i340.OrdersUseCase(gh<_i145.OrdersRepo>()),
    );
    gh.factory<_i213.HomeUseCase>(
      () => _i213.HomeUseCase(gh<_i660.HomeRepos>()),
    );
    gh.factory<_i772.GetOrderViewModel>(
      () => _i772.GetOrderViewModel(gh<_i340.OrdersUseCase>()),
    );
    gh.factory<_i313.ServicesViewModel>(
      () => _i313.ServicesViewModel(gh<_i213.HomeUseCase>()),
    );
    gh.factory<_i399.PlaceOrderViewModel>(
      () => _i399.PlaceOrderViewModel(gh<_i213.HomeUseCase>()),
    );
    gh.factory<_i449.ClientInfoViewModel>(
      () => _i449.ClientInfoViewModel(gh<_i213.HomeUseCase>()),
    );
    gh.factory<_i776.FreelancerInfoViewModel>(
      () => _i776.FreelancerInfoViewModel(gh<_i213.HomeUseCase>()),
    );
    gh.factory<_i392.FreelancersViewModel>(
      () => _i392.FreelancersViewModel(gh<_i213.HomeUseCase>()),
    );
    return this;
  }
}
