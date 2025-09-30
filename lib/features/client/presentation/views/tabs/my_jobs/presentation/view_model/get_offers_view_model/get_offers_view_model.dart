import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/client/domain/use_cases/my_jobs/get_offers_for_order_use_case/get_offers_for_order_use_case.dart';
import 'package:taskly/features/freelancer/domain/entities/offer_entity/offer_entity.dart';
import '../../../../../../../../freelancer/data/models/offer_dm/offer_dm.dart';
import 'get_offers_view_model_states.dart';

@injectable
class GetOffersViewModel extends Cubit<GetOffersViewModelStates> {
  final GetOffersForOrderUseCase getOfferUseCase;
  RealtimeChannel? _offersChannel;
  RealtimeChannel? _offersCountChannel;

  List<OfferEntity> _offers = [];
  int _offersCount = 0;

  GetOffersViewModel(this.getOfferUseCase) : super(GetOffersViewModelInitial());

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
    if (isClosed) return;
    emit(GetOffersViewModelLoading());

    final Either<Failures, List<OfferEntity>> result =
        await getOfferUseCase.call(orderId);

    if (isClosed) return;
    result.fold(
      (failure) => emit(GetOffersViewModelError(failure.message)),
      (offers) {
        _offers = offers;
        _offersCount = offers.length;
        emit(GetOffersViewModelSuccess(List.from(_offers),
            offersCount: _offersCount));
      },
    );
  } catch (e) {
    if (isClosed) return;
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
        table: 'offers',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'order_id',
          value: orderId,
        ),
        callback: (payload) {
          final updatedOffer = OfferModel.fromJson(payload.newRecord!).toEntity();

 
          if (updatedOffer.offerStatus == "withdrawn") {
            _offers.removeWhere((o) => o.id == updatedOffer.id);
          } else {
            final index = _offers.indexWhere((o) => o.id == updatedOffer.id);
            if (index != -1) {
              _offers[index] = updatedOffer;
            }
          }

          emit(GetOffersViewModelSuccess(
            List.from(_offers),
            offersCount: _offers.length,
          ));
        },
      )
      .subscribe();
}


  @override
  Future<void> close() {
    _offersChannel?.unsubscribe();
    _offersCountChannel?.unsubscribe();
    return super.close();
  }
}