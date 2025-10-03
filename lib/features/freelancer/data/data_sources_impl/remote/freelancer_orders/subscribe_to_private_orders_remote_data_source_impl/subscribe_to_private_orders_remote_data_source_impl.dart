

import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/features/freelancer/data/data_sources/remote/freelancer_orders/fetch_private_orders_remote_data_source/fetch_private_orders_remote_data_source.dart';
import '../../../../../../../core/errors/failures.dart';
import '../../../../../../../core/services/supabase_service.dart';
import '../../../../../../../core/utils/network_utils.dart';
import '../../../../../../shared/data/models/order_dm/order_dm.dart';
import '../../../../../../shared/domain/entities/order_entity/order_entity.dart';
import '../../../../data_sources/remote/freelancer_orders/subscribe_to_private_orders_remote_data_source/subscribe_to_private_orders_remote_data_source.dart';
@Injectable(as: SubscribeToPrivateOrdersRemoteDataSource)
class SubscribeToPrivateOrdersRemoteDataSourceImpl  implements SubscribeToPrivateOrdersRemoteDataSource{
  final SupabaseService _supabaseService;
   final FetchPrivateOrdersRemoteDataSource _fetchPrivateOrdersRemoteDataSource;
  SubscribeToPrivateOrdersRemoteDataSourceImpl(this._supabaseService , this._fetchPrivateOrdersRemoteDataSource);
  Stream<List<OrderEntity>> subscribeToPrivateOrders(String freelancerId) {
    if (NetworkUtils.hasInternet() == false) {
      throw NetworkFailure('No internet connection');
    }

    final controller = StreamController<List<OrderEntity>>();
    final currentOrders = <OrderEntity>[];


    _fetchPrivateOrdersRemoteDataSource.fetchPrivateOrders(freelancerId).then((result) {
      result.fold(
            (failure) => controller.addError(failure),
            (orders) {
          currentOrders.addAll(orders);
          controller.add(List.from(currentOrders));
        },
      );
    });


    final channel = _supabaseService.supabaseClient.channel('private-orders-changes');
    void handleChange(dynamic payload, String action) {
      switch (action) {
        case 'INSERT':
          final order = OrderDm.fromJson(payload.newRecord).toEntity();
          if (order.serviceType.name != 'private' || order.freelancerId != freelancerId) return;
          if (!currentOrders.any((o) => o.id == order.id)) currentOrders.insert(0, order);
          break;

        case 'UPDATE':
          final order = OrderDm.fromJson(payload.newRecord).toEntity();
          if (order.serviceType.name != 'private' || order.freelancerId != freelancerId) return;
          final index = currentOrders.indexWhere((o) => o.id == order.id);
          if (index != -1) currentOrders[index] = order;
          break;

        case 'DELETE':
          final deletedId = payload.oldRecord['id'] as String;
          currentOrders.removeWhere((o) => o.id == deletedId);
          break;
      }

      currentOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      controller.add(List.from(currentOrders));
    }


    channel
        .onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'orders',
      callback: (payload) => handleChange(payload, 'INSERT'),
    )
        .onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'orders',
      callback: (payload) => handleChange(payload, 'UPDATE'),
    )
        .onPostgresChanges(
      event: PostgresChangeEvent.delete,
      schema: 'public',
      table: 'orders',
      callback: (payload) => handleChange(payload, 'DELETE'),
    )
        .subscribe();

    controller.onCancel = () => channel.unsubscribe();

    return controller.stream;
  }
}