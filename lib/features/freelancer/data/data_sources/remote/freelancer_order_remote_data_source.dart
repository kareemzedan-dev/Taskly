import 'dart:async';
import 'package:either_dart/either.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/domain/entities/order_entity/order_entity.dart';

abstract class FreelancerOrderRemoteDataSource {
  Future<Either<Failures, List<OrderEntity>>> fetchPendingFreelancerOrders();

 
  RealtimeChannel   subscribeToPendingOrders(
    void Function(OrderEntity order, String action) onChange,
  );
}
