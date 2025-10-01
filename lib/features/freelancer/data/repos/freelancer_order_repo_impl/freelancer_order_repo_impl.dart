import 'dart:async';

import 'package:either_dart/src/either.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/freelancer/data/data_sources/remote/freelancer_order_remote_data_source.dart';
import 'package:taskly/features/freelancer/domain/repos/freelancer_order_repo/freelancer_order_repo.dart';
@Injectable(as:FreelancerOrderRepo )
class FreelancerOrderRepoImpl extends FreelancerOrderRepo{
  FreelancerOrderRemoteDataSource freelancerOrderRemoteDataSource;
  FreelancerOrderRepoImpl({required this.freelancerOrderRemoteDataSource});
  @override
  Future<Either<Failures, List<OrderEntity>>> fetchPendingFreelancerOrders (String freelancerId) {
    return freelancerOrderRemoteDataSource.fetchPendingFreelancerOrders(freelancerId);
  }

  @override
  Stream<List<OrderEntity>>  subscribeToPendingOrders(
      String freelancerId
      ) {
    return freelancerOrderRemoteDataSource.subscribeToPendingOrders( freelancerId);
  }

  @override
  Future<Either<Failures, List<OrderEntity>>> fetchPrivateOrders(String freelancerId) {
     return freelancerOrderRemoteDataSource.fetchPrivateOrders(freelancerId);
  }
  @override
  Stream<(OrderEntity, String)> subscribeToPrivateOrders(String freelancerId,  ) {
    return freelancerOrderRemoteDataSource.subscribeToPrivateOrders(
        freelancerId,);
  }
  
  @override
  Future<Either<Failures, void>> updateOrderStatus(String orderId, String status) {
 return freelancerOrderRemoteDataSource.updateOrderStatus(orderId, status);
  }
  
  @override
  Future<Either<Failures, void>> withdrawOffer(String offerId, String orderId) {
     return freelancerOrderRemoteDataSource.withdrawOffer(offerId, orderId);
  }
}