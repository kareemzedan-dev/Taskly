import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/client/domain/repos/my_jobs/my_jobs_repo.dart';
import 'package:taskly/features/freelancer/domain/entities/offer_entity/offer_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../shared/domain/entities/order_entity/order_entity.dart';

@injectable
class MyJobsUseCases {
  final MyJobsRepo myJobsRepo;

  MyJobsUseCases(this.myJobsRepo);

  // Fetch offers once
  Future<Either<Failures, List<OfferEntity>>> callGetOffers(String orderId) =>
      myJobsRepo.getOffers(orderId);

  // Realtime subscription
  RealtimeChannel subscribeToOffers({
    required String orderId,
    required void Function(int offersCount) onChange,
  }) {
    return myJobsRepo.subscribeToOffers(orderId: orderId, onChange: onChange);
  }

  Future<Either<Failures, OfferEntity>> updateOfferStatus(
    String offerId,
    String newStatus,
  ) {
    return myJobsRepo.updateOfferStatus(offerId, newStatus);
  }

  Future<Either<Failures, OrderEntity>> acceptOfferAndRejectOthers(
    String orderId,
    String offerId,
  ) {
    return myJobsRepo.acceptOfferAndRejectOthers(orderId, offerId);
  }

  RealtimeChannel subscribeToOrderStatus({
    required Map<String, String> filters,
    required void Function(OrderEntity order, String action) onChange,
  }) {
    return myJobsRepo.subscribeToOrders(filters, onChange);
  }
}
