import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';

abstract class FreelancerOrderRepo {
  Future<Either<Failures, List<OrderEntity>>> fetchPendingFreelancerOrders(String freelancerId);

  RealtimeChannel  subscribeToPendingOrders(
    void Function(OrderEntity order, String action) onChange,
  );
}