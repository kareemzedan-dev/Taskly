import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/errors/failures.dart';
import '../../entities/offer_entity/offer_entity.dart';
import '../../repos/offer_repository/offer_repository.dart';
@injectable
class GetFreelancerOffersUseCase {

  final OfferRepository  offerRepository;

  const GetFreelancerOffersUseCase({required this.offerRepository});
  Future<Either<Failures, List<OfferEntity>>> call(String freelancerId) => offerRepository.getFreelancerOffers(freelancerId);
  RealtimeChannel subscribeToOffers(
      String freelancerId,
  void Function(OfferEntity offer, String action) onChange,
  ) => offerRepository.subscribeToOffers(freelancerId, onChange);
  void unsubscribeFromOffers(RealtimeChannel channel) => offerRepository.unsubscribeFromOffers(channel);




}