import 'dart:async';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/freelancer/domain/repos/freelancer_order_repo/freelancer_order_repo.dart';

@injectable
class FreelancerOrderUseCase {
  final FreelancerOrderRepo freelancerOrderRepo;

  FreelancerOrderUseCase({required this.freelancerOrderRepo});

  Future<Either<Failures, List<OrderEntity>>> fetchPendingFreelancerOrders() =>
      freelancerOrderRepo.fetchPendingFreelancerOrders();


  RealtimeChannel  subscribeToPendingOrders(
    void Function(OrderEntity order, String action) onChange,
  ) {
    return freelancerOrderRepo.subscribeToPendingOrders(onChange);
  }
}
