import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/client/domain/use_cases/my_jobs/get_offers_for_order_use_case/get_offers_for_order_use_case.dart';
import 'package:taskly/features/freelancer/domain/entities/offer_entity/offer_entity.dart';
import 'package:taskly/features/profile/domain/entities/user_info_entity/user_info_entity.dart';
import 'package:taskly/features/profile/presentation/manager/profile_view_model/profile_view_model.dart';
import 'package:taskly/features/profile/presentation/manager/profile_view_model/profile_view_model_states.dart';
import '../../../../../../../../freelancer/data/models/offer_model/offer_model.dart';
import '../../views/widgets/offer_card.dart';
import 'get_offers_view_model_states.dart';
import '../../../../../../../../../core/di/di.dart';

enum OfferSortBy { price, delivery, rating }


@injectable
class GetOffersViewModel extends Cubit<GetOffersViewModelStates> {
  final GetOffersForOrderUseCase getOfferUseCase;
  RealtimeChannel? _offersChannel;
  RealtimeChannel? _offersCountChannel;

  List<OfferWithFreelancer> _offers = [];
  int _offersCount = 0;
  OfferSortBy? _currentSort;

  GetOffersViewModel(this.getOfferUseCase) : super(GetOffersViewModelInitial());

  void init(String orderId) async {
    await getOffers(orderId);
    subscribeToOffers(orderId: orderId);
    _subscribeToOffersCountRealtime(orderId);
  }

  /// جلب بيانات الفريلانسر من ProfileViewModel
  Future<UserInfoEntity> getUserInfoById(String userId, String role) async {
    final profileViewModel = getIt<ProfileViewModel>();
    final completer = Completer<UserInfoEntity>();

    final subscription = profileViewModel.stream.listen((state) {
      if (state is ProfileViewModelStatesSuccess) {
        completer.complete(state.userInfoEntity);
      } else if (state is ProfileViewModelStatesError) {
        completer.completeError(state.message);
      }
    });

    profileViewModel.getUserInfo(userId, role);

    final userInfo = await completer.future;
    await subscription.cancel();
    return userInfo;
  }


  Future<void> getOffers(String orderId) async {
    emit(GetOffersViewModelLoading());

    final result = await getOfferUseCase.call(orderId);
    result.fold(
          (failure) => emit(GetOffersViewModelError(failure.message)),
          (offers) async {
        List<OfferWithFreelancer> offersWithFreelancer = [];
        for (var offer in offers) {
          final user = await getUserInfoById(offer.freelancerId, "freelancer");
          offersWithFreelancer.add(
            OfferWithFreelancer(
              offer: offer,
              freelancerName: user.fullName ?? '',
              freelancerEmail: user.email ?? '',
              freelancerImage: user.profileImage ?? '',
              freelancerIsVerified: user.isVerified ?? false,
              freelancerRating: user.rating ?? 0.0,
            ),
          );
        }
        _offers = offersWithFreelancer;
        _emitSortedOffers();
      },
    );
  }

  void sortOffers(OfferSortBy sortBy) {
    _currentSort = sortBy;
    _emitSortedOffers();
  }

  void _applySort() {
    if (_currentSort == null) return;
    switch (_currentSort!) {
      case OfferSortBy.price:
        _offers.sort((a, b) => a.offer.offerAmount.compareTo(b.offer.offerAmount));
        break;
      case OfferSortBy.delivery:
        _offers.sort((a, b) => a.offer.offerDeliveryTime.compareTo(b.offer.offerDeliveryTime));
        break;
      case OfferSortBy.rating:
        _offers.sort((a, b) => b.freelancerRating.compareTo(a.freelancerRating));
        break;
    }
  }

  void _emitSortedOffers() {
    _applySort();
    emit(GetOffersViewModelSuccess(List.from(_offers), offersCount: _offers.length));
  }

  /// الاشتراك في Realtime channel لإضافة عروض جديدة
  RealtimeChannel subscribeToOffers({required String orderId}) {
    final channel = Supabase.instance.client
        .channel('offers_$orderId')
        .onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'offers',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'order_id',
        value: orderId,
      ),
      callback: (payload) async {
        final offerEntity = OfferModel.fromJson(payload.newRecord!).toEntity();
        final user = await getUserInfoById(offerEntity.freelancerId, "freelancer");

        final offerWithFreelancer = OfferWithFreelancer(
          offer: offerEntity,
          freelancerName: user.fullName ?? '',
          freelancerEmail: user.email ?? '',
          freelancerImage: user.profileImage ?? '',
          freelancerIsVerified: user.isVerified ?? false,
          freelancerRating: user.rating ?? 0.0,
        );

        _offers = List.from(_offers)..add(offerWithFreelancer);
        _emitSortedOffers();
      },
    ).subscribe();

    _offersChannel = channel;
    return channel;
  }

  /// الاشتراك لتحديث العروض
  void _subscribeToOffersCountRealtime(String orderId) {
    _offersCountChannel?.unsubscribe();
    _offersCountChannel = Supabase.instance.client
        .channel('offers_count_$orderId')
        .onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'offers',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'order_id',
        value: orderId,
      ),
      callback: (payload) async {
        final updatedOfferEntity = OfferModel.fromJson(payload.newRecord!).toEntity();
        final user = await getUserInfoById(updatedOfferEntity.freelancerId, "freelancer");

        final updatedOffer = OfferWithFreelancer(
          offer: updatedOfferEntity,
          freelancerName: user.fullName ?? '',
          freelancerEmail: user.email ?? '',
          freelancerImage: user.profileImage ?? '',
          freelancerIsVerified: user.isVerified ?? false,
          freelancerRating: user.rating ?? 0.0,
        );

        if (updatedOffer.offer.offerStatus == "withdrawn") {
          _offers = List.from(_offers)..removeWhere((o) => o.offer.id == updatedOffer.offer.id);
        } else {
          final index = _offers.indexWhere((o) => o.offer.id == updatedOffer.offer.id);
          if (index != -1) _offers[index] = updatedOffer;
        }

        _emitSortedOffers();
      },
    ).subscribe();
  }

  @override
  Future<void> close() {
    _offersChannel?.unsubscribe();
    _offersCountChannel?.unsubscribe();
    return super.close();
  }
}
