import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/offer_entity/offer_entity.dart';
import '../../../domain/use_cases/get_freelancer_offers_use_case/get_freelancer_offers_use_case.dart';
import 'get_freelancer_offers_states.dart';

@injectable
class GetFreelancerOffersViewModel extends Cubit<GetFreelancerOffersStates> {
  final GetFreelancerOffersUseCase getFreelancerOffersUseCase;

  GetFreelancerOffersViewModel(this.getFreelancerOffersUseCase)
      : super(GetFreelancerOffersLoadingState());
  Future<Either<Failures, List<OfferEntity>>> getFreelancerOffers(
      String freelancerId,
      [String? status]) async {
    try {
      emit(GetFreelancerOffersLoadingState());
      print("📡 Calling use case with freelancerId: $freelancerId and status: ${status ?? "all"}");

      final result = await getFreelancerOffersUseCase.call(freelancerId, status ?? "all");

      print("✅ Result from use case: $result");

      result.fold(
            (failure) {
          print("❌ Failure: ${failure.message}");
          emit(GetFreelancerOffersErrorState(failure.message));
        },
            (offers) {
          print("📦 Offers count: ${offers.length}");

          final modifiableOffers = List<OfferEntity>.from(offers);
          modifiableOffers.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          emit(GetFreelancerOffersSuccessState(modifiableOffers));
        },

      );
      return result;
    } catch (e, st) {
      print("🔥 Exception in getFreelancerOffers: $e\n$st");
      emit(GetFreelancerOffersErrorState(e.toString()));
      return Left(ServerFailure(e.toString()));
    }
  }

Stream<(OfferEntity, String)> subscribeToOffers(String freelancerId) {
  return getFreelancerOffersUseCase.subscribeToOffers(freelancerId);
}
  StreamSubscription? _subscription;

  void listenToOffersChanges(String freelancerId) {
    // نلغي أي اشتراك قديم
    _subscription?.cancel();

    _subscription = subscribeToOffers(freelancerId).listen((event) async {
      final (offer, action) = event;

      print("📡 Offer change detected: ${offer.id} (${offer.offerStatus}) - $action");

      // بعد أي تغيير، نعمل refresh فوري
      await getFreelancerOffers(freelancerId);
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

}
