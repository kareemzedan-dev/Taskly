import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:either_dart/src/either.dart';
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

  final SupabaseService supabaseService = SupabaseService();
  final SupabaseClient _supabase = Supabase.instance.client;
  RealtimeChannel? _ordersChannel;
  RealtimeChannel? _privateOrdersChannel;
  @override
  Future<Either<Failures, List<OrderEntity>>> fetchPendingFreelancerOrders(String freelancerId) async {
    try {
      var result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.none) {
        return Left(NetworkFailure('No internet connection'));
      }

      final offersResponse = await _supabase
          .from('offers')
          .select('order_id')
          .eq('freelancer_id', freelancerId);

      final offeredOrderIds = (offersResponse as List)
          .map((e) => e['order_id'] as String)
          .toList();

      final response = await _supabase
          .from('orders')
          .select('*')
          .eq('status', 'Pending')
          .not('id', 'in', offeredOrderIds.isEmpty ? [''] : offeredOrderIds);

      if (response.isEmpty) {
        return Right([]);
      }

      final orders = (response as List)
          .map((json) => OrderDm.fromJson(json))
          .toList();

      return Right(orders);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  RealtimeChannel subscribeToPendingOrders(
      void Function(OrderEntity order, String action) onChange,
      ) {
    _ordersChannel = supabaseService.subscribe(
      table: 'orders',
      filters: {'status': "Pending"},
      onChange: (record, action) {
        final order = OrderDm.fromJson(record);
        if(order.status == OrderStatus.Pending) {
          onChange(order, action);
        }
      },
    );
    return _ordersChannel!;
  }

  void unsubscribeFromPendingOrders() {
    supabaseService.unsubscribe(table: 'orders');
    _ordersChannel = null;
  }



  @override
  Future<Either<Failures, List<OrderEntity>>> fetchPrivateOrders(
      String freelancerId) async {
    try {
      var result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.none) {
        return Left(NetworkFailure('No internet connection'));
      }

      final response = await _supabase
          .from('orders')
          .select('*')
          .eq('freelancer_id', freelancerId);

      if (response.isEmpty) {
        return Right([]);
      }

      final orders =
      (response as List).map((json) => OrderDm.fromJson(json)).toList();

      return Right(orders);
    } catch (e) {
      return Left(ServerFailure("Failed to fetch private orders: $e"));
    }
  }
@override
  RealtimeChannel subscribeToPrivateOrders(
      String freelancerId,
      void Function(OrderEntity order, String action) onChange,
      ) {
    _privateOrdersChannel = supabaseService.subscribe(
      table: 'orders',
      filters: {'freelancer_id': freelancerId},
      onChange: (record, action) {
        final order = OrderDm.fromJson(record);
        onChange(order, action);
      },
    );

    return _privateOrdersChannel!;
  }

  void unsubscribeFromPrivateOrders() {
    supabaseService.unsubscribe(table: 'orders');
    _privateOrdersChannel = null;
  }
}
