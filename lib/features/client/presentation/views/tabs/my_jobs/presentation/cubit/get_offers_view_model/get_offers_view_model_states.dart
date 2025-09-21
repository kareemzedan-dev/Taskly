import 'package:taskly/features/freelancer/domain/entities/offer_entity/offer_entity.dart';

class GetOffersViewModelStates {}

class GetOffersViewModelInitial extends GetOffersViewModelStates {}

class GetOffersViewModelLoading extends GetOffersViewModelStates {}

class GetOffersViewModelSuccess extends GetOffersViewModelStates {
  final List<OfferEntity> offers;
  final int offersCount;


  GetOffersViewModelSuccess(
      this.offers, {
        this.offersCount = 0,

      });
}

class GetOffersViewModelError extends GetOffersViewModelStates {
  String message;
  GetOffersViewModelError(this.message);
}