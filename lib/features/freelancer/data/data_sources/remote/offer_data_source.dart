import 'package:either_dart/either.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/freelancer/domain/entities/offer_entity/offer_entity.dart';

import '../../../../shared/domain/entities/order_entity/order_entity.dart';

abstract class OfferRemoteDataSource {
  Future<Either<Failures,OfferEntity>> placeOffer(OfferEntity offerEntity);
  Future<Either<Failures, List<OfferEntity>>> getFreelancerOffers(String freelancerId);
  Future<Either<Failures, OrderEntity>> fetchOrderDetails(String orderId );
  RealtimeChannel subscribeToOffers(
      String freelancerId,
      void Function(OfferEntity offer, String action) onChange,
      );
  void unsubscribeFromOffers(RealtimeChannel channel);


}