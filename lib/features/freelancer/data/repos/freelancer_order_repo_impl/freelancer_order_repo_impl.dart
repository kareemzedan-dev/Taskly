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
  RealtimeChannel  subscribeToPendingOrders(void Function(OrderEntity order, String action) onChange) {
    return freelancerOrderRemoteDataSource.subscribeToPendingOrders(onChange);
  }
}