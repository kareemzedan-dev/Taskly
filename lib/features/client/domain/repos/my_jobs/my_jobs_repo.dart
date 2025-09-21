import 'package:either_dart/either.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/freelancer/domain/entities/offer_entity/offer_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../shared/domain/entities/order_entity/order_entity.dart';

abstract class MyJobsRepo {

  Future<Either<Failures, List<OfferEntity>>> getOffers(String orderId);


  RealtimeChannel subscribeToOffers({
    required String orderId,
    required void Function(int offersCount) onChange,
  });

  Future< Either<Failures,OfferEntity >> updateOfferStatus(
      String offerId, String newStatus);

  Future<Either<Failures, OrderEntity>> acceptOfferAndRejectOthers(
      String orderId,
      String offerId,
      );
  RealtimeChannel subscribeToOrders(Map<String, String> filters,
      void Function(OrderEntity order, String action) onChange);


}
