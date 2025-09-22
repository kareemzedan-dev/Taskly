import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/offer_entity/offer_entity.dart';
import '../../../domain/use_cases/get_freelancer_offers_use_case/get_freelancer_offers_use_case.dart';
import 'get_freelancer_offers_states.dart';
@injectable
class GetFreelancerOffersViewModel extends Cubit<GetFreelancerOffersStates> {
  final GetFreelancerOffersUseCase getFreelancerOffersUseCase;
  RealtimeChannel? _offersChannel;


  GetFreelancerOffersViewModel(this.getFreelancerOffersUseCase)
      : super(GetFreelancerOffersLoadingState());

  Future<Either<Failures, List<OfferEntity>>> getFreelancerOffers(
      String freelancerId,[String? status]) async {
    try {
      emit(GetFreelancerOffersLoadingState());
      final result = await getFreelancerOffersUseCase.call(freelancerId, status ?? "all");

      result.fold(
            (failure) => emit(GetFreelancerOffersErrorState(failure.message)),
            (offers) => emit(GetFreelancerOffersSuccessState(offers)),
      );
      return result;
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  RealtimeChannel subscribeToOffers(
      String freelancerId,
      void Function(OfferEntity offer, String action) onChange,

      ) {

    _offersChannel = getFreelancerOffersUseCase.subscribeToOffers(freelancerId, onChange);
    return _offersChannel!;
  }

  void unsubscribeFromOffers() {
    if (_offersChannel != null) {
      getFreelancerOffersUseCase.unsubscribeFromOffers(_offersChannel!);
      _offersChannel = null;
    }
  }

  @override
  Future<void> close() {
    unsubscribeFromOffers();
    return super.close();
  }
}
