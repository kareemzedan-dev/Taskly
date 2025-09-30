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
  final SupabaseClient _supabase;

  RealtimeChannel? _ordersChannel;
  RealtimeChannel? _privateOrdersChannel;

  FreelancerOrderRemoteDataSourceImpl({
    required SupabaseService supabaseService,
  })  : _supabaseService = supabaseService,
        _supabase = Supabase.instance.client;

  @override
  Future<Either<Failures, List<OrderEntity>>> fetchPendingFreelancerOrders(
      String freelancerId) async {
    try {
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.none) {
        return Left(NetworkFailure('No internet connection'));
      }

      final offersResponse = await _supabase
          .from('offers')
          .select('order_id')
          .eq('freelancer_id', freelancerId);

      final offeredOrderIds =
          (offersResponse as List).map((e) => e['order_id'] as String).toList();

      final response = await _supabase
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
  RealtimeChannel subscribeToPendingOrders(
      void Function(OrderEntity order, String action) onChange) {
_ordersChannel = _supabase
    .channel('public_orders_channel')
    .onPostgresChanges(
      event: PostgresChangeEvent.all, // insert, update, delete
      schema: 'public',
      table: 'orders',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'status',
        value: 'Pending',
      ),
      callback: (payload) {
        final record = payload.newRecord ?? payload.oldRecord;
        if (record != null) {
          final order = OrderDm.fromJson(record);
          if (order.status == OrderStatus.Pending &&
              order.serviceType == 'public') {
            onChange(order, payload.eventType.name); // insert/update/delete
          }
        }
      },
    )
    .subscribe();


    return _ordersChannel!;
  }

  void unsubscribeFromPendingOrders() {
    if (_ordersChannel != null) {
      _supabaseService.unsubscribe(table: 'orders');
      _ordersChannel = null;
    }
  }

  @override
  Future<Either<Failures, List<OrderEntity>>> fetchPrivateOrders(
      String freelancerId) async {
    try {
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.none) {
        return Left(NetworkFailure('No internet connection'));
      }

      final response = await _supabase
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
  RealtimeChannel subscribeToPrivateOrders(String freelancerId,
      void Function(OrderEntity order, String action) onChange) {
    _privateOrdersChannel = _supabaseService.subscribe(
      table: 'orders',
      filters: {
        'freelancer_id': freelancerId,
        'service_type': 'private',
      },
      onChange: (record, action) {
        final order = OrderDm.fromJson(record);
        if (order.serviceType == 'private') {
          onChange(order, action);
        }
      },
    );

    return _privateOrdersChannel!;
  }

  void unsubscribeFromPrivateOrders() {
    if (_privateOrdersChannel != null) {
      _supabaseService.unsubscribe(table: 'orders');
      _privateOrdersChannel = null;
    }
  }

  void unsubscribeAll() {
    _supabaseService.unsubscribeAll();
    _ordersChannel = null;
    _privateOrdersChannel = null;
  }

  @override
  Future<Either<Failures, void>> updateOrderStatus(
      String orderId, String status) async {
    try {
      _supabase.from('orders').update({'status': status}).eq('id', orderId);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to update order status: $e'));
    }
  }

  @override
  Future<Either<Failures, void>> withdrawOffer(
      String offerId, String orderId) async {
    try {
      await _supabase
          .from('offers')
          .update({'status': 'withdrawn'}).eq('id', offerId);

      await _supabase.rpc(
        'decrement_offers_count',
        params: {'order_id': orderId},
      );

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to withdraw offer: $e'));
    }
  }
}
