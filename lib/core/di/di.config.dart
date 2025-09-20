// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import '../../features/attachments/data/data_sources/remote/attachments_remote_data_source/attachments_remote_data_source.dart'
    as _i1020;
import '../../features/attachments/data/data_sources_impl/remote/attachments_remote_data_source_impl/attachments_remote_data_source_impl.dart'
    as _i568;
import '../../features/attachments/data/repositories/attachments_repository_impl/attachments_repository_impl.dart'
    as _i727;
import '../../features/attachments/domain/repositories/attachments_repository/attachments_repository.dart'
    as _i345;
import '../../features/attachments/domain/use_cases/delete_attachments/delete_attachments_use_case.dart'
    as _i416;
import '../../features/attachments/domain/use_cases/download_attachments/download_attachments.dart'
    as _i197;
import '../../features/attachments/domain/use_cases/upload_attachments/upload_attachments_use_case.dart'
    as _i231;
import '../../features/attachments/presentation/manager/delete_attachments_view_model/delete_attachments_view_model.dart'
    as _i195;
import '../../features/attachments/presentation/manager/download_attachments_view_model/download_attachments_view_model.dart'
    as _i338;
import '../../features/attachments/presentation/manager/upload_attachments_view_model/upload_attachments_view_model.dart'
    as _i11;
import '../../features/auth/data/data_sources/remote/auth_remote_data_source.dart'
    as _i432;
import '../../features/auth/data/data_sources_impl/remote/auth_remote_data_source_impl.dart'
    as _i420;
import '../../features/auth/data/repos_impl/auth/auth_repo_impl.dart' as _i529;
import '../../features/auth/domain/repos/auth/auth_repo.dart' as _i746;
import '../../features/auth/domain/use_cases/auth/auth_use_case.dart' as _i630;
import '../../features/auth/presentation/cubit/auth_view_model.dart' as _i745;
import '../../features/client/data/data_sources/remote/home_remote_data_source.dart'
    as _i307;
import '../../features/client/data/data_sources/remote/my_jobs_remote_data_source.dart'
    as _i41;
import '../../features/client/data/data_sources_impl/remote/home_remote_data_source_impl.dart'
    as _i426;
import '../../features/client/data/data_sources_impl/remote/my_jobs_remote_data_source_impl.dart'
    as _i95;
import '../../features/client/data/repos/home/home_repo_impl.dart' as _i86;
import '../../features/client/data/repos/my_jobs/my_jobs_repo_impl.dart'
    as _i1023;
import '../../features/client/domain/repos/home/home_repos.dart' as _i660;
import '../../features/client/domain/repos/my_jobs/my_jobs_repo.dart' as _i896;
import '../../features/client/domain/use_cases/home/home_use_case.dart'
    as _i213;
import '../../features/client/domain/use_cases/my_jobs/my_jobs_use_cases.dart'
    as _i356;
import '../../features/client/presentation/cubit/client_info_view_model/client_info_view_model.dart'
    as _i449;
import '../../features/client/presentation/views/tabs/home/presentation/cubit/freelancers_view_model/freelancers_view_model.dart'
    as _i392;
import '../../features/client/presentation/views/tabs/home/presentation/cubit/place_order_view_model/place_order_view_model.dart'
    as _i399;
import '../../features/client/presentation/views/tabs/home/presentation/cubit/services_view_model/services_view_model.dart'
    as _i313;
import '../../features/client/presentation/views/tabs/my_jobs/presentation/cubit/get_offers_view_model/get_offers_view_model.dart'
    as _i946;
import '../../features/client/presentation/views/tabs/my_jobs/presentation/cubit/get_order_view_model.dart/get_order_view_model.dart'
    as _i772;
import '../../features/client/presentation/views/tabs/my_jobs/presentation/cubit/update_offer_status_view_model/update_offer_status_view_model.dart'
    as _i73;
import '../../features/freelancer/data/data_sources/remote/freelancer_order_remote_data_source.dart'
    as _i297;
import '../../features/freelancer/data/data_sources/remote/offer_data_source.dart'
    as _i358;
import '../../features/freelancer/data/data_sources_impl/remote/freelancer_order_remote_data_source_impl.dart'
    as _i500;
import '../../features/freelancer/data/data_sources_impl/remote/offer_data_source_imple.dart'
    as _i33;
import '../../features/freelancer/data/repos/freelancer_order_repo_impl/freelancer_order_repo_impl.dart'
    as _i535;
import '../../features/freelancer/data/repos/offer_repository_impl/offer_repository_impl.dart'
    as _i792;
import '../../features/freelancer/domain/repos/freelancer_order_repo/freelancer_order_repo.dart'
    as _i75;
import '../../features/freelancer/domain/repos/offer_repository/offer_repository.dart'
    as _i363;
import '../../features/freelancer/domain/use_cases/fetch_order_details_use_case/fetch_order_details_use_case.dart'
    as _i988;
import '../../features/freelancer/domain/use_cases/freelancer_order_use_case/freelancer_order_use_case.dart'
    as _i171;
import '../../features/freelancer/domain/use_cases/get_freelancer_offers_use_case/get_freelancer_offers_use_case.dart'
    as _i90;
import '../../features/freelancer/domain/use_cases/send_offer_use_case/send_offer_use_case.dart'
    as _i626;
import '../../features/freelancer/presentation/cubit/fetch_order_details_view_model/fetch_order_details_view_model.dart'
    as _i644;
import '../../features/freelancer/presentation/cubit/freelancer_info_view_model/freelancer_info_view_model.dart'
    as _i776;
import '../../features/freelancer/presentation/cubit/get_freelancer_offers_view_model/get_freelancer_offers_view_model.dart'
    as _i552;
import '../../features/freelancer/presentation/views/tabs/find_work/presentation/cubit/freelancer_pending_order_view_model/freelancer_pending_order_view_model.dart'
    as _i636;
import '../../features/freelancer/presentation/views/tabs/find_work/presentation/cubit/send_offer_view_model/send_offer_view_model.dart'
    as _i1052;
import '../../features/profile/data/data_sources/profile_remote_data_source.dart'
    as _i1012;
import '../../features/profile/data/data_sources_implem/profile_remote_data_source_impl.dart'
    as _i51;
import '../../features/profile/data/repositories/profile/profile_repo_impl.dart'
    as _i541;
import '../../features/profile/domain/repositories/profile/profile_repo.dart'
    as _i821;
import '../../features/profile/domain/use_cases/profile/profile_use_case.dart'
    as _i585;
import '../../features/profile/presentation/manager/profile_view_model/profile_view_model.dart'
    as _i1003;
import '../../features/shared/data/data_sources/remote/impl/orders_remote_data_source_impl.dart'
    as _i237;
import '../../features/shared/data/data_sources/remote/orders_remote_data_source.dart'
    as _i159;
import '../../features/shared/data/repos/orders/orders_repo_impl.dart' as _i553;
import '../../features/shared/domain/repos/orders/orders_repo.dart' as _i46;
import '../../features/shared/domain/use_cases/orders/orders_use_case.dart'
    as _i759;
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
    gh.factory<_i297.FreelancerOrderRemoteDataSource>(
      () => _i500.FreelancerOrderRemoteDataSourceImpl(),
    );
    gh.factory<_i41.MyJobsRemoteDataSource>(
      () => _i95.MyJobsRemoteDataSourceImpl(),
    );
    gh.factory<_i159.OrdersRemoteDataSource>(
      () => _i237.OrdersRemoteDataSourceImpl(),
    );
    gh.factory<_i896.MyJobsRepo>(
      () => _i1023.MyJobsRepoImpl(
        myJobsRemoteDataSource: gh<_i41.MyJobsRemoteDataSource>(),
      ),
    );
    gh.factory<_i358.OfferRemoteDataSource>(
      () => _i33.OfferRemoteDataSourceImpl(),
    );
    gh.factory<_i1012.ProfileRemoteDataSource>(
      () => _i51.ProfileRemoteDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i432.AuthRemoteDataSource>(
      () => _i420.AuthRemoteDataSourceImpl(),
    );
    gh.factory<_i46.OrdersRepo>(
      () => _i553.OrdersRepoImpl(
        ordersRemoteDataSource: gh<_i159.OrdersRemoteDataSource>(),
      ),
    );
    gh.factory<_i821.ProfileRepo>(
      () => _i541.ProfileRepoImpl(gh<_i1012.ProfileRemoteDataSource>()),
    );
    gh.factory<_i307.HomeRemoteDataSource>(
      () =>
          _i426.HomeRemoteDataSourceImpl(supabase: gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i1020.AttachmentsRemoteDataSource>(
      () => _i568.AttachmentsRemoteDataSourceImpl(
        gh<_i361.Dio>(),
        gh<_i454.SupabaseClient>(),
      ),
    );
    gh.factory<_i759.OrdersUseCase>(
      () => _i759.OrdersUseCase(gh<_i46.OrdersRepo>()),
    );
    gh.factory<_i660.HomeRepos>(
      () => _i86.HomeRepoImpl(
        homeremoteDataSource: gh<_i307.HomeRemoteDataSource>(),
      ),
    );
    gh.factory<_i363.OfferRepository>(
      () => _i792.OfferRepositoryImpl(gh<_i358.OfferRemoteDataSource>()),
    );
    gh.factory<_i746.AuthRepo>(
      () => _i529.AuthRepoImpl(gh<_i432.AuthRemoteDataSource>()),
    );
    gh.factory<_i356.MyJobsUseCases>(
      () => _i356.MyJobsUseCases(gh<_i896.MyJobsRepo>()),
    );
    gh.factory<_i772.GetOrderViewModel>(
      () => _i772.GetOrderViewModel(gh<_i759.OrdersUseCase>()),
    );
    gh.factory<_i988.FetchOrderDetailsUseCase>(
      () => _i988.FetchOrderDetailsUseCase(gh<_i363.OfferRepository>()),
    );
    gh.factory<_i644.FetchOrderDetailsViewModel>(
      () => _i644.FetchOrderDetailsViewModel(
        gh<_i988.FetchOrderDetailsUseCase>(),
      ),
    );
    gh.factory<_i585.ProfileUseCase>(
      () => _i585.ProfileUseCase(gh<_i821.ProfileRepo>()),
    );
    gh.factory<_i75.FreelancerOrderRepo>(
      () => _i535.FreelancerOrderRepoImpl(
        freelancerOrderRemoteDataSource:
            gh<_i297.FreelancerOrderRemoteDataSource>(),
      ),
    );
    gh.factory<_i630.AuthUseCase>(
      () => _i630.AuthUseCase(gh<_i746.AuthRepo>()),
    );
    gh.factory<_i345.AttachmentsRepository>(
      () => _i727.AttachmentsRepositoryImpl(
        gh<_i1020.AttachmentsRemoteDataSource>(),
      ),
    );
    gh.factory<_i213.HomeUseCase>(
      () => _i213.HomeUseCase(gh<_i660.HomeRepos>()),
    );
    gh.factory<_i449.ClientInfoViewModel>(
      () => _i449.ClientInfoViewModel(gh<_i585.ProfileUseCase>()),
    );
    gh.factory<_i776.FreelancerInfoViewModel>(
      () => _i776.FreelancerInfoViewModel(gh<_i585.ProfileUseCase>()),
    );
    gh.factory<_i1003.ProfileViewModel>(
      () => _i1003.ProfileViewModel(gh<_i585.ProfileUseCase>()),
    );
    gh.factory<_i946.GetOffersViewModel>(
      () => _i946.GetOffersViewModel(gh<_i356.MyJobsUseCases>()),
    );
    gh.factory<_i73.UpdateOfferStatusViewModel>(
      () => _i73.UpdateOfferStatusViewModel(gh<_i356.MyJobsUseCases>()),
    );
    gh.factory<_i745.AuthViewModel>(
      () => _i745.AuthViewModel(authUseCase: gh<_i630.AuthUseCase>()),
    );
    gh.factory<_i90.GetFreelancerOffersUseCase>(
      () => _i90.GetFreelancerOffersUseCase(
        offerRepository: gh<_i363.OfferRepository>(),
      ),
    );
    gh.factory<_i626.SendOfferUseCase>(
      () =>
          _i626.SendOfferUseCase(offerRepository: gh<_i363.OfferRepository>()),
    );
    gh.factory<_i416.DeleteAttachmentsUseCase>(
      () => _i416.DeleteAttachmentsUseCase(
        attachmentsRepository: gh<_i345.AttachmentsRepository>(),
      ),
    );
    gh.factory<_i231.UploadAttachmentsUseCase>(
      () => _i231.UploadAttachmentsUseCase(
        attachmentsRepository: gh<_i345.AttachmentsRepository>(),
      ),
    );
    gh.factory<_i197.DownloadAttachmentsUseCase>(
      () => _i197.DownloadAttachmentsUseCase(gh<_i345.AttachmentsRepository>()),
    );
    gh.factory<_i171.FreelancerOrderUseCase>(
      () => _i171.FreelancerOrderUseCase(
        freelancerOrderRepo: gh<_i75.FreelancerOrderRepo>(),
      ),
    );
    gh.factory<_i338.DownloadAttachmentsViewModel>(
      () => _i338.DownloadAttachmentsViewModel(
        gh<_i197.DownloadAttachmentsUseCase>(),
      ),
    );
    gh.factory<_i399.PlaceOrderViewModel>(
      () => _i399.PlaceOrderViewModel(gh<_i213.HomeUseCase>()),
    );
    gh.factory<_i313.ServicesViewModel>(
      () => _i313.ServicesViewModel(gh<_i213.HomeUseCase>()),
    );
    gh.factory<_i552.GetFreelancerOffersViewModel>(
      () => _i552.GetFreelancerOffersViewModel(
        gh<_i90.GetFreelancerOffersUseCase>(),
      ),
    );
    gh.factory<_i392.FreelancersViewModel>(
      () => _i392.FreelancersViewModel(gh<_i213.HomeUseCase>()),
    );
    gh.factory<_i11.UploadAttachmentsViewModel>(
      () =>
          _i11.UploadAttachmentsViewModel(gh<_i231.UploadAttachmentsUseCase>()),
    );
    gh.factory<_i1052.SendOfferViewModel>(
      () => _i1052.SendOfferViewModel(gh<_i626.SendOfferUseCase>()),
    );
    gh.factory<_i636.FreelancerPendingOrdersViewModel>(
      () => _i636.FreelancerPendingOrdersViewModel(
        gh<_i171.FreelancerOrderUseCase>(),
      ),
    );
    gh.factory<_i195.DeleteAttachmentsViewModel>(
      () => _i195.DeleteAttachmentsViewModel(
        gh<_i416.DeleteAttachmentsUseCase>(),
      ),
    );
    return this;
  }
}
