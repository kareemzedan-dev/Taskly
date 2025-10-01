import 'dart:async';
import 'package:either_dart/either.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';

abstract class FreelancerOrderRemoteDataSource {
  Future<Either<Failures, List<OrderEntity>>> fetchPendingFreelancerOrders(String freelancerId);

  Stream<List<OrderEntity>> subscribeToPendingOrders(
      String freelancerId
      );
  Future<Either<Failures, List<OrderEntity>>> fetchPrivateOrders(String freelancerId);
   Stream<(OrderEntity, String)> subscribeToPrivateOrders(
    String freelancerId,
  

      );
  Future<Either<Failures, void>> updateOrderStatus(String orderId, String status);
  Future<Either<Failures, void>> withdrawOffer(String offerId, String orderId);

}
