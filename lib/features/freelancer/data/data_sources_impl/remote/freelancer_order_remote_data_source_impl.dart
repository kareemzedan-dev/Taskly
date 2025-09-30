import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/core/services/supabase_service.dart';
import 'package:taskly/features/shared/data/models/order_dm/order_dm.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/freelancer/data/data_sources/remote/freelancer_order_remote_data_source.dart';
@Injectable(as: FreelancerOrderRemoteDataSource)
class FreelancerOrderRemoteDataSourceImpl
    extends FreelancerOrderRemoteDataSource {
  final SupabaseService _supabaseService;
 

  FreelancerOrderRemoteDataSourceImpl({
    required SupabaseService supabaseService,
  }) : _supabaseService = supabaseService;

  @override
  Future<Either<Failures, List<OrderEntity>>> fetchPendingFreelancerOrders(
      String freelancerId) async {
    try {
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.none) {
        return Left(NetworkFailure('No internet connection'));
      }

      final offersResponse = await _supabaseService.supabaseClient
          .from('offers')
          .select('order_id')
          .eq('freelancer_id', freelancerId);

      final offeredOrderIds =
          (offersResponse as List).map((e) => e['order_id'] as String).toList();

      final response = await _supabaseService.supabaseClient
          .from('orders')
          .select('*')
          .eq('status', 'Pending')
          .eq('service_type', 'public')
          .not('id', 'in', offeredOrderIds.isEmpty ? [''] : offeredOrderIds);

      if ((response as List).isEmpty) return Right([]);

      final orders = response.map((json) => OrderDm.fromJson(json)).toList();
      return Right(orders);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch pending orders: $e'));
    }
  }

@override
Stream<List<OrderEntity>> subscribeToPendingOrders() {
  return _supabaseService
      .subscribeToTable(
        table: 'orders',
        filter: "status=eq.Pending,service_type=eq.public",
      )
      .map((records) =>
          records.map((record) => OrderDm.fromJson(record).toEntity()).toList());
}


 

  @override
  Future<Either<Failures, List<OrderEntity>>> fetchPrivateOrders(
      String freelancerId) async {
    try {
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.none) {
        return Left(NetworkFailure('No internet connection'));
      }

      final response = await _supabaseService.supabaseClient
          .from('orders')
          .select('*')
          .eq('freelancer_id', freelancerId)
          .eq('service_type', 'private');

      if ((response as List).isEmpty) return Right([]);

      final orders = response.map((json) => OrderDm.fromJson(json)).toList();
      return Right(orders);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch private orders: $e'));
    }
  }

@override
Stream<(OrderEntity, String)> subscribeToPrivateOrders(String freelancerId) {
  return _supabaseService
      .subscribeToTable(
        table: 'orders',
        filter: "freelancer_id=eq.$freelancerId,service_type=eq.private",
      )
      .map((records) {
        return records.map((record) {
          final order = OrderDm.fromJson(record).toEntity();
          // هنا هرجع الـ order ومعاه الـ action (insert/update/delete)
          return (order, record['action'] as String);
        });
      })
      // flatMap عشان اخلي stream يرجع event واحد مش list
      .asyncExpand((events) => Stream.fromIterable(events));
}

 

 

  @override
  Future<Either<Failures, void>> updateOrderStatus(
      String orderId, String status) async {
    try {
      await _supabaseService.supabaseClient
          .from('orders')
          .update({'status': status}).eq('id', orderId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to update order status: $e'));
    }
  }

  @override
  Future<Either<Failures, void>> withdrawOffer(
      String offerId, String orderId) async {
    try {
      await _supabaseService.supabaseClient
          .from('offers')
          .update({'status': 'withdrawn'}).eq('id', offerId);

      await _supabaseService.supabaseClient.rpc(
        'decrement_offers_count',
        params: {'order_id': orderId},
      );

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to withdraw offer: $e'));
    }
  }
}
