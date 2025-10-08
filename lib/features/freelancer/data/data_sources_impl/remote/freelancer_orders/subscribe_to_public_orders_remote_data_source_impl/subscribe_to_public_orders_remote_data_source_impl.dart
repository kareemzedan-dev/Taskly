import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';

import '../../../../../../../core/errors/failures.dart';
import '../../../../../../../core/services/supabase_service.dart';
import '../../../../../../../core/utils/network_utils.dart';
import '../../../../../../shared/data/models/order_dm/order_dm.dart';
import '../../../../data_sources/remote/freelancer_orders/fetch_public_orders_remote_data_source/fetch_public_orders_remote_data_source.dart';
import '../../../../data_sources/remote/freelancer_orders/subscribe_to_public_orders_remote_data_source/subscribe_to_public_orders_remote_data_source.dart';

@Injectable(as: SubscribeToPublicOrdersRemoteDataSource)
class SubscribeToPublicOrdersRemoteDataSourceImpl
    implements SubscribeToPublicOrdersRemoteDataSource {
  final SupabaseService _supabaseService;
  final FetchPublicOrdersRemoteDataSource _fetchPublicOrdersRemoteDataSource;

  SubscribeToPublicOrdersRemoteDataSourceImpl(
      this._supabaseService, this._fetchPublicOrdersRemoteDataSource);

  @override
  Stream<List<OrderEntity>> subscribeToPublicOrders(String freelancerId) async* {
    if (!await NetworkUtils.hasInternet()  ) {
      throw const NetworkFailure('No internet connection');
    }

    final controller = StreamController<List<OrderEntity>>();
    final currentOrders = <OrderEntity>[];

    final initialResult =
    await _fetchPublicOrdersRemoteDataSource.fetchPublicOrders(freelancerId);

    initialResult.fold(
          (failure) => controller.addError(failure),
          (orders) {
        currentOrders.addAll(orders);
        controller.add(List.from(currentOrders));
      },
    );

    final channel = _supabaseService.supabaseClient.channel('orders-changes');

    void handleOrderChange(OrderEntity order) {
      if (order.serviceType.name != 'public') return;

      final index = currentOrders.indexWhere((o) => o.id == order.id);
      if (index != -1) {
        currentOrders[index] = order;
      } else {
        currentOrders.insert(0, order);
      }
      controller.add(List.from(currentOrders));
    }

    channel.onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'orders',
      callback: (payload) {
        final order = OrderDm.fromJson(payload.newRecord).toEntity();
        handleOrderChange(order);
      },
    );

    channel.onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'orders',
      callback: (payload) {
        final order = OrderDm.fromJson(payload.newRecord).toEntity();
        handleOrderChange(order);
      },
    );

    channel.onPostgresChanges(
      event: PostgresChangeEvent.delete,
      schema: 'public',
      table: 'orders',
      callback: (payload) {
        final deletedId = payload.oldRecord['id'] as String;
        currentOrders.removeWhere((o) => o.id == deletedId);
        controller.add(List.from(currentOrders));
      },
    ).subscribe();

    controller.onCancel = () {
      channel.unsubscribe();
      controller.close();
    };

    yield* controller.stream;
  }
}
