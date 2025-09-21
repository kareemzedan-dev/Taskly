import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/client/domain/use_cases/my_jobs/my_jobs_use_cases.dart';
import 'package:taskly/features/freelancer/domain/entities/offer_entity/offer_entity.dart';
import '../../../../../../../../freelancer/data/models/offer_dm/offer_dm.dart';
import 'get_offers_view_model_states.dart';

@injectable
class GetOffersViewModel extends Cubit<GetOffersViewModelStates> {
  final MyJobsUseCases myJobsUseCases;
  RealtimeChannel? _offersChannel;
  RealtimeChannel? _offersCountChannel;

  List<OfferEntity> _offers = [];
  int _offersCount = 0;

  GetOffersViewModel(this.myJobsUseCases) : super(GetOffersViewModelInitial());

  void init(String orderId) async {
    await getOffers(orderId);
    subscribeToOffers(
      orderId: orderId,
      onChange: (offersList) {
        _offers = offersList;
        _offersCount = _offers.length;
        emit(GetOffersViewModelSuccess(List.from(_offers), offersCount: _offersCount));
      },
    );
    _subscribeToOffersCountRealtime(orderId);
  }



  Future<void> getOffers(String orderId) async {
    try {
      emit(GetOffersViewModelLoading());

      final Either<Failures, List<OfferEntity>> result =
      await myJobsUseCases.callGetOffers(orderId);

      result.fold(
            (failure) => emit(GetOffersViewModelError(failure.message)),
            (offers) {
          _offers = offers;
          _offersCount = offers.length;
          emit(GetOffersViewModelSuccess(List.from(_offers), offersCount: _offersCount));
        },
      );
    } catch (e) {
      emit(GetOffersViewModelError(e.toString()));
    }
  }

  RealtimeChannel subscribeToOffers({
    required String orderId,
    required void Function(List<OfferEntity>) onChange,
  }) {
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
      callback: (payload) {

        final offer = OfferModel.fromJson(payload.newRecord!).toEntity();
        _offers.add(offer);
        onChange(List.from(_offers));
      },
    )
        .subscribe();

    return channel;
  }



  void _subscribeToOffersCountRealtime(String orderId) {
    _offersCountChannel?.unsubscribe();

 
    _offersCountChannel = Supabase.instance.client
        .channel('offers_count_$orderId')
        .onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'orders',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'id',
        value: orderId,
      ),
      callback: (payload) {
        final newCount = payload.newRecord['offers_count'] as int?;
        if (newCount != null) {
          _offersCount = newCount;
          emit(GetOffersViewModelSuccess(List.from(_offers), offersCount: _offersCount));
        }
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