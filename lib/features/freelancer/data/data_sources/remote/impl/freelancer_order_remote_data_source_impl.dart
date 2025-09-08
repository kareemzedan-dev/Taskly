import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:either_dart/src/either.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/core/services/supabase_service.dart';
import 'package:taskly/data/models/order_dm/order_dm.dart';
import 'package:taskly/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/freelancer/data/data_sources/remote/freelancer_order_remote_data_source.dart';

@Injectable(as: FreelancerOrderRemoteDataSource)
class FreelancerOrderRemoteDataSourceImpl
    extends FreelancerOrderRemoteDataSource {
  final SupabaseService supabaseService = SupabaseService();
  final SupabaseClient _supabase = Supabase.instance.client;

  RealtimeChannel? _ordersChannel;

  @override
  Future<Either<Failures, List<OrderEntity>>>
  fetchPendingFreelancerOrders() async {
    try {
      var result = await Connectivity().checkConnectivity();
      if (result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile)) {
        final response = await supabaseService.getDataFromSupabase(
          tableName: "orders",
          filters: {"status": "pending"},
        );

        if (response == null || response.isEmpty) {
          return Right([]);
        }

        final orders =
            response.map<OrderEntity>((json) {
              return OrderDm.fromJson(json);
            }).toList();

        return Right(orders);
      } else {
        return Left(NetworkFailure('No internet connection'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  RealtimeChannel subscribeToPendingOrders(
    void Function(OrderEntity, String action) onChange,
  ) {
    final channel =
        _supabase.channel('public:orders')
          ..onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'orders',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'status',
              value: 'pending',
            ),
            callback: (payload) {
              final order = OrderDm.fromJson(payload.newRecord);
              onChange(order, 'insert');
            },
          )
          ..onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: 'orders',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'status',
              value: 'pending',
            ),
            callback: (payload) {
              final order = OrderDm.fromJson(payload.newRecord);
              onChange(order, 'update');
            },
          )
          ..onPostgresChanges(
            event: PostgresChangeEvent.delete,
            schema: 'public',
            table: 'orders',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'status',
              value: 'pending',
            ),
            callback: (payload) {
              final order = OrderDm.fromJson(payload.oldRecord);
              onChange(order, 'delete');
            },
          );
    channel.subscribe();
    return channel;
  }

  void unsubscribe() {
    if (_ordersChannel != null) {
      _supabase.removeChannel(_ordersChannel!);
      _ordersChannel = null;
    }
  }
}
