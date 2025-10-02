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
import '../../features/client/data/data_sources/remote/delete_order_data_source/delete_order_data_source.dart'
    as _i673;
import '../../features/client/data/data_sources/remote/home_remote_data_source.dart'
    as _i307;
import '../../features/client/data/data_sources/remote/my_jobs_remote_data_source.dart'
    as _i41;
import '../../features/client/data/data_sources_impl/remote/delete_order_data_source_impl/delete_order_data_source_impl.dart'
    as _i930;
import '../../features/client/data/data_sources_impl/remote/home_remote_data_source_impl.dart'
    as _i426;
import '../../features/client/data/data_sources_impl/remote/my_jobs_remote_data_source_impl.dart'
    as _i95;
import '../../features/client/data/repos/home/home_repo_impl.dart' as _i86;
import '../../features/client/data/repos/my_jobs/delete_order_repo_impl/delete_order_repo_impl.dart'
    as _i402;
import '../../features/client/data/repos/my_jobs/my_jobs_repo_impl.dart'
    as _i1023;
import '../../features/client/domain/repos/home/home_repos.dart' as _i660;
import '../../features/client/domain/repos/my_jobs/delete_order_repo/delete_order_repo.dart'
    as _i337;
import '../../features/client/domain/repos/my_jobs/my_jobs_repo.dart' as _i896;
import '../../features/client/domain/use_cases/home/get_all_freelancers_use_case/get_all_freelancers_use_case.dart'
    as _i988;
import '../../features/client/domain/use_cases/home/get_all_services_use_case/get_all_services_use_case.dart'
    as _i628;
import '../../features/client/domain/use_cases/home/place_order_use_case/place_order_use_case.dart'
    as _i904;
import '../../features/client/domain/use_cases/my_jobs/accept_offer_use_case/accept_offer_use_case.dart'
    as _i213;
import '../../features/client/domain/use_cases/my_jobs/delete_order_use_case/delete_order_use_case.dart'
    as _i859;
import '../../features/client/domain/use_cases/my_jobs/get_offers_for_order_use_case/get_offers_for_order_use_case.dart'
    as _i863;
import '../../features/client/domain/use_cases/my_jobs/subscribe_to_offer_status_use_case/subscribe_to_offer_status_use_case.dart'
    as _i86;
import '../../features/client/domain/use_cases/my_jobs/subscribe_to_order_status_use_case/subscribe_to_order_status_use_case.dart'
    as _i576;
import '../../features/client/domain/use_cases/my_jobs/subscribe_to_orders_use_case/subscribe_to_orders_use_case.dart'
    as _i454;
import '../../features/client/domain/use_cases/my_jobs/update_offer_status_use_case/update_offer_status_use_case.dart'
    as _i530;
import '../../features/client/presentation/views/tabs/home/presentation/view_model/fetch_all_freelancers_view_model/fetch_all_freelancers_view_model.dart'
    as _i670;
import '../../features/client/presentation/views/tabs/home/presentation/view_model/freelancers_view_model/freelancers_view_model.dart'
    as _i938;
import '../../features/client/presentation/views/tabs/home/presentation/view_model/place_order_view_model/place_order_view_model.dart'
    as _i779;
import '../../features/client/presentation/views/tabs/home/presentation/view_model/services_view_model/services_view_model.dart'
    as _i869;
import '../../features/client/presentation/views/tabs/my_jobs/presentation/view_model/client_order_status_view_model/client_order_status_view_model.dart'
    as _i765;
import '../../features/client/presentation/views/tabs/my_jobs/presentation/view_model/delete_order_view_model/delete_order_view_model.dart'
    as _i413;
import '../../features/client/presentation/views/tabs/my_jobs/presentation/view_model/get_offers_view_model/get_offers_view_model.dart'
    as _i920;
import '../../features/client/presentation/views/tabs/my_jobs/presentation/view_model/get_order_view_model.dart/get_order_view_model.dart'
    as _i855;
import '../../features/client/presentation/views/tabs/my_jobs/presentation/view_model/update_offer_status_view_model/update_offer_status_view_model.dart'
    as _i376;
import '../../features/freelancer/data/data_sources/remote/freelancer_order_remote_data_source.dart'
    as _i297;
import '../../features/freelancer/data/data_sources/remote/offer_data_source.dart'
    as _i358;
import '../../features/freelancer/data/data_sources_impl/remote/freelancer_order_remote_data_source_impl.dart'
    as _i500;
import '../../features/freelancer/data/data_sources_impl/remote/offer_remote_data_source_impl.dart'
    as _i35;
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
import '../../features/freelancer/domain/use_cases/fetch_private_orders_use_case/fetch_private_orders_use_case.dart'
    as _i2;
import '../../features/freelancer/domain/use_cases/freelancer_order_use_case/freelancer_order_use_case.dart'
    as _i171;
import '../../features/freelancer/domain/use_cases/get_freelancer_offers_use_case/get_freelancer_offers_use_case.dart'
    as _i90;
import '../../features/freelancer/domain/use_cases/send_offer_use_case/send_offer_use_case.dart'
    as _i626;
import '../../features/freelancer/domain/use_cases/update_order_status_use_case/update_order_status_use_case.dart'
    as _i785;
import '../../features/freelancer/domain/use_cases/withdraw_offer_use_case/withdraw_offer_use_case.dart'
    as _i380;
import '../../features/freelancer/presentation/cubit/fetch_order_details_view_model/fetch_order_details_view_model.dart'
    as _i644;
import '../../features/freelancer/presentation/cubit/freelancer_info_view_model/freelancer_info_view_model.dart'
    as _i776;
import '../../features/freelancer/presentation/cubit/get_freelancer_offers_view_model/get_freelancer_offers_view_model.dart'
    as _i552;
import '../../features/freelancer/presentation/cubit/update_order_status_view_model/update_order_status_view_model.dart'
    as _i975;
import '../../features/freelancer/presentation/cubit/withdraw_offer_view_model/withdraw_offer_view_model.dart'
    as _i278;
import '../../features/freelancer/presentation/views/tabs/find_work/presentation/cubit/freelancer_pending_order_view_model/freelancer_pending_order_view_model.dart'
    as _i636;
import '../../features/freelancer/presentation/views/tabs/find_work/presentation/cubit/freelancer_private_orders_view_model/freelancer_private_orders_view_model.dart'
    as _i416;
import '../../features/freelancer/presentation/views/tabs/find_work/presentation/cubit/send_offer_view_model/send_offer_view_model.dart'
    as _i1052;
import '../../features/messages/data/data_sources/remote/delete_message_remote_data_source/delete_message_remote_data_source.dart'
    as _i191;
import '../../features/messages/data/data_sources/remote/get_accepted_order_message_remote_data_source/get_accepted_order_message_remote_data_source.dart'
    as _i1006;
import '../../features/messages/data/data_sources/remote/get_admin_messages_remote_data_source/get_admin_messages_remote_data_source.dart'
    as _i815;
import '../../features/messages/data/data_sources/remote/get_conversations_remote_data_source/get_conversations_remote_data_source.dart'
    as _i572;
import '../../features/messages/data/data_sources/remote/get_order_messages_remote_data_source/get_order_messages_remote_data_source.dart'
    as _i219;
import '../../features/messages/data/data_sources/remote/mark_messages_as_read_remote_data_source/mark_messages_as_read_remote_data_source.dart'
    as _i458;
import '../../features/messages/data/data_sources/remote/send_messages_remote_data_source/send_messages_remote_data_source.dart'
    as _i902;
import '../../features/messages/data/data_sources/remote/subscribe_to_admin_messages_remote_data_source/subscribe_to_admin_messages_remote_data_source.dart'
    as _i798;
import '../../features/messages/data/data_sources/remote/subscribe_to_messages_remote_data_source/subscribe_to_messages_remote_data_source.dart'
    as _i462;
import '../../features/messages/data/data_sources_impl/remote/delete_message_remote_data_source_impl/delete_message_remote_data_source_impl.dart'
    as _i65;
import '../../features/messages/data/data_sources_impl/remote/get_accepted_order_message_remote_data_source_impl/get_accepted_order_message_remote_data_source_impl.dart'
    as _i113;
import '../../features/messages/data/data_sources_impl/remote/get_admin_messages_remote_data_source_impl/get_admin_messages_remote_data_source_impl.dart'
    as _i422;
import '../../features/messages/data/data_sources_impl/remote/get_conversations_remote_data_source_impl/get_conversations_remote_data_source_impl.dart'
    as _i160;
import '../../features/messages/data/data_sources_impl/remote/get_order_messages_remote_data_source_impl/get_order_messages_remote_data_source_impl.dart'
    as _i652;
import '../../features/messages/data/data_sources_impl/remote/mark_messages_as_read_remote_data_source_impl/mark_messages_as_read_remote_data_source_impl.dart'
    as _i1015;
import '../../features/messages/data/data_sources_impl/remote/send_messages_remote_data_source_impl/send_messages_remote_data_source_impl.dart'
    as _i522;
import '../../features/messages/data/data_sources_impl/remote/subscribe_to_admin_messages_remote_data_source_impl/subscribe_to_admin_messages_remote_data_source_impl.dart'
    as _i579;
import '../../features/messages/data/data_sources_impl/remote/subscribe_to_messages_remote_data_source_impl/subscribe_to_messages_remote_data_source_impl.dart'
    as _i894;
import '../../features/messages/data/repositories/delete_message_repo_impl/delete_message_repo_impl.dart'
    as _i718;
import '../../features/messages/data/repositories/get_accepted_order_message_repo_impl/get_accepted_order_message_repo_impl.dart'
    as _i1048;
import '../../features/messages/data/repositories/get_admin_messages_repo_impl/get_admin_messages_repo_impl.dart'
    as _i1006;
import '../../features/messages/data/repositories/get_conversation_repo_impl/get_conversation_repo_impl.dart'
    as _i402;
import '../../features/messages/data/repositories/get_order_messages_repo_impl/get_order_messages_repo_impl.dart'
    as _i661;
import '../../features/messages/data/repositories/mark_messages_as_read_repo_impl/mark_messages_as_read_repo_impl.dart'
    as _i718;
import '../../features/messages/data/repositories/send_messages_repo_impl/send_messages_repo_impl.dart'
    as _i406;
import '../../features/messages/data/repositories/subscribe_to_admin_messages_repo_impl/subscribe_to_admin_messages_repo_impl.dart'
    as _i1062;
import '../../features/messages/data/repositories/subscribe_to_messages_repo_impl/subscribe_to_messages_repo_impl.dart'
    as _i92;
import '../../features/messages/domain/repositories/messages_repos/delete_message_repo/delete_message_repo.dart'
    as _i469;
import '../../features/messages/domain/repositories/messages_repos/get_accepted_order_message_repo/get_accepted_order_message_repo.dart'
    as _i81;
import '../../features/messages/domain/repositories/messages_repos/get_admin_messages_repo/get_admin_messages_repo.dart'
    as _i686;
import '../../features/messages/domain/repositories/messages_repos/get_conversation_repo/get_conversation_repo.dart'
    as _i257;
import '../../features/messages/domain/repositories/messages_repos/get_order_messages_repo/get_order_messages_repo.dart'
    as _i833;
import '../../features/messages/domain/repositories/messages_repos/mark_messages_as_read_repo/mark_messages_as_read_repo.dart'
    as _i113;
import '../../features/messages/domain/repositories/messages_repos/send_messages_repo/send_messages_repo.dart'
    as _i201;
import '../../features/messages/domain/repositories/messages_repos/subscribe_to_admin_messages_repo/subscribe_to_admin_messages_repo.dart'
    as _i953;
import '../../features/messages/domain/repositories/messages_repos/subscribe_to_messages_repo/subscribe_to_messages_repo.dart'
    as _i196;
import '../../features/messages/domain/use_cases/delete_message_use_case/delete_message_use_case.dart'
    as _i988;
import '../../features/messages/domain/use_cases/get_accepted_order_message_use_case/get_accepted_order_message_use_case.dart'
    as _i997;
import '../../features/messages/domain/use_cases/get_admin_messages_use_case/get_admin_messages_use_case.dart'
    as _i841;
import '../../features/messages/domain/use_cases/get_conversations_use_case/get_conversations_use_case.dart'
    as _i61;
import '../../features/messages/domain/use_cases/get_order_messages_use_case/get_order_messages_use_case.dart'
    as _i416;
import '../../features/messages/domain/use_cases/mark_message_read_use_case/mark_message_read_use_case.dart'
    as _i367;
import '../../features/messages/domain/use_cases/send_message_use_case/send_message_use_case.dart'
    as _i366;
import '../../features/messages/domain/use_cases/subscribe_to_admin_messages_use_case/subscribe_to_admin_messages_use_case.dart'
    as _i1022;
import '../../features/messages/domain/use_cases/subscribe_to_messages_use_case/subscribe_to_messages_use_case.dart'
    as _i172;
import '../../features/messages/presentation/manager/get_accepted_order_message_view_model/get_accepted_order_message_view_model.dart'
    as _i12;
import '../../features/messages/presentation/manager/get_admin_messages_view_model/get_admin_messages_view_model.dart'
    as _i662;
import '../../features/messages/presentation/manager/get_conversations_view_model/get_conversations_view_model.dart'
    as _i42;
import '../../features/messages/presentation/manager/get_messages_view_model/get_messages_view_model.dart'
    as _i389;
import '../../features/messages/presentation/manager/send_message_view_model/send_message_view_model.dart'
    as _i602;
import '../../features/messages/presentation/manager/subscribe_to_admin_messages_view_model/subscribe_to_admin_messages_view_model.dart'
    as _i448;
import '../../features/messages/presentation/manager/subscribe_to_messages_view_model/subscribe_to_messages_view_model.dart'
    as _i61;
import '../../features/payments/data/data_sources/remote/create_payment_remote_data_source.dart'
    as _i968;
import '../../features/payments/data/data_sources/remote/get_payment_remote_data_source.dart'
    as _i315;
import '../../features/payments/data/data_sources_impl/remote/create_payment_remote_data_source_impl.dart'
    as _i795;
import '../../features/payments/data/data_sources_impl/remote/get_payment_remote_data_source_impl.dart'
    as _i696;
import '../../features/payments/data/repositories/payment_repo_impl/payment_repo_impl.dart'
    as _i488;
import '../../features/payments/domain/repositories/payment_repos/payment_repo.dart'
    as _i815;
import '../../features/payments/domain/use_cases/create_payment_use_case/create_payment_use_case.dart'
    as _i618;
import '../../features/payments/domain/use_cases/get_payment/get_payment.dart'
    as _i848;
import '../../features/payments/presentation/manager/create_payment_view_model/create_payment_view_model.dart'
    as _i517;
import '../../features/payments/presentation/manager/get_payment_view_model/get_payment_view_model.dart'
    as _i483;
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
import '../../features/reviews/data/data_sources/remote/reviews_remote_data_source/reviews_remote_data_source.dart'
    as _i114;
import '../../features/reviews/data/data_sources_impl/remote/reviews_remote_data_source_impl/reviews_remote_data_source_impl.dart'
    as _i716;
import '../../features/reviews/data/repositories/reviews_repo_impl/reviews_repo_impl.dart'
    as _i81;
import '../../features/reviews/domain/repositories/reviews_repo/reviews_repo.dart'
    as _i420;
import '../../features/reviews/domain/use_cases/get_user_reviews_use_case/get_user_reviews_use_case.dart'
    as _i701;
import '../../features/reviews/presentation/manager/get_user_reviews_view_model/get_user_reviews_view_model.dart'
    as _i163;
import '../../features/shared/data/data_sources/remote/impl/orders_remote_data_source_impl.dart'
    as _i237;
import '../../features/shared/data/data_sources/remote/orders_remote_data_source.dart'
    as _i159;
import '../../features/shared/data/repos/orders/orders_repo_impl.dart' as _i553;
import '../../features/shared/domain/repos/orders/orders_repo.dart' as _i46;
import '../../features/shared/domain/use_cases/orders/orders_use_case.dart'
    as _i759;
import '../../features/shared/presentation/manager/subscribe_to_order_record_view_model/subscribe_to_order_record_view_model.dart'
    as _i28;
import '../services/file_uploaded_services.dart' as _i383;
import '../services/supabase_service.dart' as _i374;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i383.FilePickerService>(() => _i383.FilePickerService());
    gh.factory<_i114.ReviewsRemoteDataSource>(
        () => _i716.ReviewsRemoteDataSourceImpl(gh<_i454.SupabaseClient>()));
    gh.singleton<_i374.SupabaseService>(
      () => _i374.SupabaseService(gh<_i454.SupabaseClient>()),
      dispose: (i) => i.dispose(),
    );
    gh.factory<_i458.MarkMessagesAsReadRemoteDataSource>(() =>
        _i1015.MarkMessagesAsReadRemoteDataSourceImpl(
            supabaseService: gh<_i374.SupabaseService>()));
    gh.factory<_i1006.GetAcceptedOrderMessageRemoteDataSource>(() =>
        _i113.GetAcceptedOrderMessageRemoteDataSourceImpl(
            supabaseService: gh<_i374.SupabaseService>()));
    gh.factory<_i315.GetPaymentRemoteDataSource>(
        () => _i696.GetPaymentRemoteDataSourceImpl(gh<_i454.SupabaseClient>()));
    gh.factory<_i968.CreatePaymentRemoteDataSource>(() =>
        _i795.CreatePaymentRemoteDataSourceImpl(gh<_i454.SupabaseClient>()));
    gh.factory<_i1012.ProfileRemoteDataSource>(
        () => _i51.ProfileRemoteDataSourceImpl(gh<_i374.SupabaseService>()));
    gh.factory<_i815.PaymentRepos>(() => _i488.CreatePaymentRepoImpl(
          gh<_i968.CreatePaymentRemoteDataSource>(),
          gh<_i315.GetPaymentRemoteDataSource>(),
        ));
    gh.factory<_i219.GetOrderMessagesRemoteDataSource>(() =>
        _i652.GetOrderMessagesRemoteDataSourceImpl(
            gh<_i374.SupabaseService>()));
    gh.factory<_i358.OfferRemoteDataSource>(
        () => _i35.OfferRemoteDataSourceImpl(gh<_i374.SupabaseService>()));
    gh.factory<_i902.SendMessagesRemoteDataSource>(() =>
        _i522.SendMessagesRemoteDataSourceImpl(gh<_i374.SupabaseService>()));
    gh.factory<_i420.ReviewsRepo>(() => _i81.ReviewsRepoImpl(
        remoteDataSource: gh<_i114.ReviewsRemoteDataSource>()));
    gh.factory<_i432.AuthRemoteDataSource>(
        () => _i420.AuthRemoteDataSourceImpl(gh<_i374.SupabaseService>()));
    gh.factory<_i833.GetOrderMessagesRepo>(() => _i661.GetOrderMessagesRepoImpl(
        remoteDataSource: gh<_i219.GetOrderMessagesRemoteDataSource>()));
    gh.factory<_i673.DeleteOrderRemoteDataSource>(
        () => _i930.DeleteOrderDataSourceImpl(gh<_i374.SupabaseService>()));
    gh.factory<_i363.OfferRepository>(
        () => _i792.OfferRepositoryImpl(gh<_i358.OfferRemoteDataSource>()));
    gh.factory<_i746.AuthRepo>(
        () => _i529.AuthRepoImpl(gh<_i432.AuthRemoteDataSource>()));
    gh.factory<_i191.DeleteMessageRemoteDataSource>(() =>
        _i65.DeleteMessageRemoteDataSourceImpl(gh<_i374.SupabaseService>()));
    gh.factory<_i572.GetConversationsRemoteDataSource>(() =>
        _i160.GetUserConversationsRemoteDataSourceImpl(
            gh<_i374.SupabaseService>()));
    gh.factory<_i159.OrdersRemoteDataSource>(
        () => _i237.OrdersRemoteDataSourceImpl(gh<_i374.SupabaseService>()));
    gh.factory<_i41.MyJobsRemoteDataSource>(
        () => _i95.MyJobsRemoteDataSourceImpl(gh<_i374.SupabaseService>()));
    gh.lazySingleton<_i416.GetOrderMessagesUseCase>(
        () => _i416.GetOrderMessagesUseCase(gh<_i833.GetOrderMessagesRepo>()));
    gh.factory<_i257.GetConversationRepo>(() => _i402.GetConversationRepoImpl(
        gh<_i572.GetConversationsRemoteDataSource>()));
    gh.factory<_i815.GetAdminMessagesRemoteDataSource>(() =>
        _i422.GetAdminMessagesRemoteDataSourceImpl(
            gh<_i374.SupabaseService>()));
    gh.factory<_i798.SubscribeToAdminMessagesRemoteDataSource>(() =>
        _i579.SubscribeToAdminMessagesRemoteDataSourceImpl(
            gh<_i374.SupabaseService>()));
    gh.factory<_i988.FetchOrderDetailsUseCase>(
        () => _i988.FetchOrderDetailsUseCase(gh<_i363.OfferRepository>()));
    gh.factory<_i644.FetchOrderDetailsViewModel>(() =>
        _i644.FetchOrderDetailsViewModel(gh<_i988.FetchOrderDetailsUseCase>()));
    gh.factory<_i462.SubscribeToMessagesRemoteDataSource>(() =>
        _i894.SubscribeToMessagesRemoteDataSourceImpl(
            supabaseService: gh<_i374.SupabaseService>()));
    gh.factory<_i701.GetUserReviewsUseCase>(
        () => _i701.GetUserReviewsUseCase(gh<_i420.ReviewsRepo>()));
    gh.factory<_i307.HomeRemoteDataSource>(() => _i426.HomeRemoteDataSourceImpl(
        supabaseService: gh<_i374.SupabaseService>()));
    gh.factory<_i1020.AttachmentsRemoteDataSource>(
        () => _i568.AttachmentsRemoteDataSourceImpl(
              gh<_i361.Dio>(),
              gh<_i374.SupabaseService>(),
              gh<_i454.SupabaseClient>(),

            ));
    gh.factory<_i953.SubscribeToAdminMessagesRepo>(() =>
        _i1062.SubscribeToAdminMessagesRepoImpl(
            gh<_i798.SubscribeToAdminMessagesRemoteDataSource>()));
    gh.factory<_i297.FreelancerOrderRemoteDataSource>(() =>
        _i500.FreelancerOrderRemoteDataSourceImpl(
            supabaseService: gh<_i374.SupabaseService>()));
    gh.factory<_i630.AuthUseCase>(
        () => _i630.AuthUseCase(gh<_i746.AuthRepo>()));
    gh.factory<_i896.MyJobsRepo>(() => _i1023.MyJobsRepoImpl(
        myJobsRemoteDataSource: gh<_i41.MyJobsRemoteDataSource>()));
    gh.factory<_i113.MarkMessagesAsReadRepo>(() =>
        _i718.MarkMessagesAsReadRepoImpl(
            gh<_i458.MarkMessagesAsReadRemoteDataSource>()));
    gh.factory<_i81.GetAcceptedOrderMessageRepo>(() =>
        _i1048.GetAcceptedOrderMessageRepoImpl(
            getAcceptedOrderMessageRemoteDataSource:
                gh<_i1006.GetAcceptedOrderMessageRemoteDataSource>()));
    gh.factory<_i61.GetConversationsUseCase>(
        () => _i61.GetConversationsUseCase(gh<_i257.GetConversationRepo>()));
    gh.factory<_i337.DeleteOrderRepo>(() =>
        _i402.DeleteOrderRepoImpl(gh<_i673.DeleteOrderRemoteDataSource>()));
    gh.factory<_i686.GetAdminMessagesRepo>(() =>
        _i1006.GetAdminMessagesRepoImpl(
            gh<_i815.GetAdminMessagesRemoteDataSource>()));
    gh.factory<_i618.CreatePaymentUseCase>(
        () => _i618.CreatePaymentUseCase(gh<_i815.PaymentRepos>()));
    gh.factory<_i196.SubscribeToMessagesRepo>(() =>
        _i92.SubscribeToMessagesRepoImpl(
            remoteDataSource: gh<_i462.SubscribeToMessagesRemoteDataSource>()));
    gh.factory<_i46.OrdersRepo>(() => _i553.OrdersRepoImpl(
        ordersRemoteDataSource: gh<_i159.OrdersRemoteDataSource>()));
    gh.factory<_i821.ProfileRepo>(
        () => _i541.ProfileRepoImpl(gh<_i1012.ProfileRemoteDataSource>()));
    gh.factory<_i345.AttachmentsRepository>(() =>
        _i727.AttachmentsRepositoryImpl(
            gh<_i1020.AttachmentsRemoteDataSource>()));
    gh.factory<_i163.GetUserReviewsViewModel>(
        () => _i163.GetUserReviewsViewModel(gh<_i701.GetUserReviewsUseCase>()));
    gh.factory<_i389.GetMessagesViewModel>(
        () => _i389.GetMessagesViewModel(gh<_i416.GetOrderMessagesUseCase>()));
    gh.factory<_i848.GetPaymentUseCase>(
        () => _i848.GetPaymentUseCase(gh<_i815.PaymentRepos>()));
    gh.factory<_i745.AuthViewModel>(
        () => _i745.AuthViewModel(authUseCase: gh<_i630.AuthUseCase>()));
    gh.factory<_i201.SendMessagesRepo>(() =>
        _i406.SendMessagesRepoImpl(gh<_i902.SendMessagesRemoteDataSource>()));
    gh.factory<_i759.OrdersUseCase>(
        () => _i759.OrdersUseCase(gh<_i46.OrdersRepo>()));
    gh.factory<_i660.HomeRepos>(() => _i86.HomeRepoImpl(
        homeremoteDataSource: gh<_i307.HomeRemoteDataSource>()));
    gh.factory<_i469.DeleteMessageRepo>(() =>
        _i718.DeleteMessageRepoImpl(gh<_i191.DeleteMessageRemoteDataSource>()));
    gh.factory<_i90.GetFreelancerOffersUseCase>(() =>
        _i90.GetFreelancerOffersUseCase(
            offerRepository: gh<_i363.OfferRepository>()));
    gh.factory<_i626.SendOfferUseCase>(() =>
        _i626.SendOfferUseCase(offerRepository: gh<_i363.OfferRepository>()));
    gh.lazySingleton<_i988.DeleteMessageUseCase>(
        () => _i988.DeleteMessageUseCase(gh<_i469.DeleteMessageRepo>()));
    gh.factory<_i483.GetPaymentViewModel>(
        () => _i483.GetPaymentViewModel(gh<_i848.GetPaymentUseCase>()));
    gh.factory<_i416.DeleteAttachmentsUseCase>(() =>
        _i416.DeleteAttachmentsUseCase(
            attachmentsRepository: gh<_i345.AttachmentsRepository>()));
    gh.factory<_i231.UploadAttachmentsUseCase>(() =>
        _i231.UploadAttachmentsUseCase(
            attachmentsRepository: gh<_i345.AttachmentsRepository>()));
    gh.lazySingleton<_i367.MarkMessagesAsReadUseCase>(() =>
        _i367.MarkMessagesAsReadUseCase(gh<_i113.MarkMessagesAsReadRepo>()));
    gh.factory<_i197.DownloadAttachmentsUseCase>(() =>
        _i197.DownloadAttachmentsUseCase(gh<_i345.AttachmentsRepository>()));
    gh.factory<_i1022.SubscribeToAdminMessagesUseCase>(() =>
        _i1022.SubscribeToAdminMessagesUseCase(
            gh<_i953.SubscribeToAdminMessagesRepo>()));
    gh.factory<_i213.AcceptOfferUseCase>(
        () => _i213.AcceptOfferUseCase(gh<_i896.MyJobsRepo>()));
    gh.factory<_i863.GetOffersForOrderUseCase>(
        () => _i863.GetOffersForOrderUseCase(gh<_i896.MyJobsRepo>()));
    gh.factory<_i86.SubscribeToOfferStatusUseCase>(
        () => _i86.SubscribeToOfferStatusUseCase(gh<_i896.MyJobsRepo>()));
    gh.factory<_i454.SubscribetToOrdersUseCase>(
        () => _i454.SubscribetToOrdersUseCase(gh<_i896.MyJobsRepo>()));
    gh.factory<_i576.SubscribeToOrderStatusUseCase>(
        () => _i576.SubscribeToOrderStatusUseCase(gh<_i896.MyJobsRepo>()));
    gh.factory<_i530.UpdateOfferStatusUseCase>(
        () => _i530.UpdateOfferStatusUseCase(gh<_i896.MyJobsRepo>()));
    gh.factory<_i859.DeleteOrderUseCase>(
        () => _i859.DeleteOrderUseCase(gh<_i337.DeleteOrderRepo>()));
    gh.factory<_i172.SubscribeToMessagesUseCase>(() =>
        _i172.SubscribeToMessagesUseCase(gh<_i196.SubscribeToMessagesRepo>()));
    gh.factory<_i338.DownloadAttachmentsViewModel>(() =>
        _i338.DownloadAttachmentsViewModel(
            gh<_i197.DownloadAttachmentsUseCase>()));
    gh.factory<_i997.GetAcceptedOrderMessagesUseCase>(() =>
        _i997.GetAcceptedOrderMessagesUseCase(
            gh<_i81.GetAcceptedOrderMessageRepo>()));
    gh.factory<_i855.GetOrderViewModel>(() => _i855.GetOrderViewModel(
          gh<_i759.OrdersUseCase>(),
          gh<_i576.SubscribeToOrderStatusUseCase>(),
        ));
    gh.factory<_i988.GetAllFreelancersUseCase>(
        () => _i988.GetAllFreelancersUseCase(gh<_i660.HomeRepos>()));
    gh.factory<_i585.ProfileUseCase>(
        () => _i585.ProfileUseCase(gh<_i821.ProfileRepo>()));
    gh.factory<_i552.GetFreelancerOffersViewModel>(() =>
        _i552.GetFreelancerOffersViewModel(
            gh<_i90.GetFreelancerOffersUseCase>()));
    gh.factory<_i75.FreelancerOrderRepo>(() => _i535.FreelancerOrderRepoImpl(
        freelancerOrderRemoteDataSource:
            gh<_i297.FreelancerOrderRemoteDataSource>()));
    gh.factory<_i517.CreatePaymentViewModel>(
        () => _i517.CreatePaymentViewModel(gh<_i618.CreatePaymentUseCase>()));
    gh.factory<_i28.SubscribeOrdersRecordViewModel>(() =>
        _i28.SubscribeOrdersRecordViewModel(
            subscribeOrderUseCase: gh<_i759.OrdersUseCase>()));
    gh.factory<_i448.SubscribeToAdminMessagesViewModel>(() =>
        _i448.SubscribeToAdminMessagesViewModel(
            gh<_i1022.SubscribeToAdminMessagesUseCase>()));
    gh.factory<_i42.GetConversationsViewModel>(() =>
        _i42.GetConversationsViewModel(gh<_i61.GetConversationsUseCase>()));
    gh.factory<_i12.GetAcceptedOrderMessageViewModel>(() =>
        _i12.GetAcceptedOrderMessageViewModel(
            gh<_i997.GetAcceptedOrderMessagesUseCase>()));
    gh.factory<_i841.GetAdminMessagesUseCase>(
        () => _i841.GetAdminMessagesUseCase(gh<_i686.GetAdminMessagesRepo>()));
    gh.lazySingleton<_i366.SendMessageUseCase>(
        () => _i366.SendMessageUseCase(gh<_i201.SendMessagesRepo>()));
    gh.factory<_i662.GetAdminMessagesViewModel>(() =>
        _i662.GetAdminMessagesViewModel(gh<_i841.GetAdminMessagesUseCase>()));
    gh.factory<_i920.GetOffersViewModel>(
        () => _i920.GetOffersViewModel(gh<_i863.GetOffersForOrderUseCase>()));
    gh.factory<_i11.UploadAttachmentsViewModel>(() =>
        _i11.UploadAttachmentsViewModel(gh<_i231.UploadAttachmentsUseCase>()));
    gh.factory<_i376.UpdateOfferStatusViewModel>(
        () => _i376.UpdateOfferStatusViewModel(
              gh<_i530.UpdateOfferStatusUseCase>(),
              gh<_i213.AcceptOfferUseCase>(),
            ));
    gh.factory<_i628.GetAllServicesUseCase>(
        () => _i628.GetAllServicesUseCase(gh<_i660.HomeRepos>()));
    gh.factory<_i904.PlaceOrderUseCase>(
        () => _i904.PlaceOrderUseCase(gh<_i660.HomeRepos>()));
    gh.factory<_i776.FreelancerInfoViewModel>(
        () => _i776.FreelancerInfoViewModel(gh<_i585.ProfileUseCase>()));
    gh.factory<_i1003.ProfileViewModel>(
        () => _i1003.ProfileViewModel(gh<_i585.ProfileUseCase>()));
    gh.factory<_i1052.SendOfferViewModel>(
        () => _i1052.SendOfferViewModel(gh<_i626.SendOfferUseCase>()));
    gh.factory<_i670.FetchAllFreelancersViewModel>(() =>
        _i670.FetchAllFreelancersViewModel(
            gh<_i988.GetAllFreelancersUseCase>()));
    gh.factory<_i938.FreelancersViewModel>(
        () => _i938.FreelancersViewModel(gh<_i988.GetAllFreelancersUseCase>()));
    gh.factory<_i413.DeleteOrderViewModel>(
        () => _i413.DeleteOrderViewModel(gh<_i859.DeleteOrderUseCase>()));
    gh.factory<_i61.SubscribeToMessagesViewModel>(() =>
        _i61.SubscribeToMessagesViewModel(
            gh<_i172.SubscribeToMessagesUseCase>()));
    gh.factory<_i195.DeleteAttachmentsViewModel>(() =>
        _i195.DeleteAttachmentsViewModel(gh<_i416.DeleteAttachmentsUseCase>()));
    gh.factory<_i779.PlaceOrderViewModel>(
        () => _i779.PlaceOrderViewModel(gh<_i904.PlaceOrderUseCase>()));
    gh.factory<_i765.ClientOrderStatusViewModel>(() =>
        _i765.ClientOrderStatusViewModel(
            gh<_i454.SubscribetToOrdersUseCase>()));
    gh.factory<_i171.FreelancerOrderUseCase>(() => _i171.FreelancerOrderUseCase(
        freelancerOrderRepo: gh<_i75.FreelancerOrderRepo>()));
    gh.factory<_i602.SendMessageViewModel>(
        () => _i602.SendMessageViewModel(gh<_i366.SendMessageUseCase>()));
    gh.factory<_i2.FetchPrivateOrdersUseCase>(
        () => _i2.FetchPrivateOrdersUseCase(gh<_i75.FreelancerOrderRepo>()));
    gh.factory<_i785.UpdateOrderStatusUseCase>(
        () => _i785.UpdateOrderStatusUseCase(gh<_i75.FreelancerOrderRepo>()));
    gh.factory<_i380.WithdrawOfferUseCase>(
        () => _i380.WithdrawOfferUseCase(gh<_i75.FreelancerOrderRepo>()));
    gh.factory<_i869.ServicesViewModel>(
        () => _i869.ServicesViewModel(gh<_i628.GetAllServicesUseCase>()));
    gh.factory<_i278.WithdrawOfferViewModel>(
        () => _i278.WithdrawOfferViewModel(gh<_i380.WithdrawOfferUseCase>()));
    gh.factory<_i975.UpdateOrderStatusViewModel>(() =>
        _i975.UpdateOrderStatusViewModel(gh<_i785.UpdateOrderStatusUseCase>()));
    gh.factory<_i416.FreelancerPrivateOrdersViewModel>(() =>
        _i416.FreelancerPrivateOrdersViewModel(
            gh<_i2.FetchPrivateOrdersUseCase>()));
    gh.factory<_i636.FreelancerPendingOrdersViewModel>(() =>
        _i636.FreelancerPendingOrdersViewModel(
            gh<_i171.FreelancerOrderUseCase>()));
    return this;
  }
}
