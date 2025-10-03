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
class SubscribeToPublicOrdersRemoteDataSourceImpl implements SubscribeToPublicOrdersRemoteDataSource {
  final SupabaseService _supabaseService;
  final FetchPublicOrdersRemoteDataSource _fetchPublicOrdersRemoteDataSource;
  SubscribeToPublicOrdersRemoteDataSourceImpl(this._supabaseService,this._fetchPublicOrdersRemoteDataSource);


  Stream<List<OrderEntity>> subscribeToPublicOrders(String freelancerId) async* {
    if (NetworkUtils.hasInternet() == false) {
      throw NetworkFailure('No internet connection');
    }

    final controller = StreamController<List<OrderEntity>>();
    final currentOrders = <OrderEntity>[];

    // 1- تحميل الحالة الأولية
    final initialResult = await _fetchPublicOrdersRemoteDataSource.fetchPublicOrders(freelancerId);
    initialResult.fold(
          (failure) => controller.addError(failure),
          (orders) {
        currentOrders.addAll(orders);
        controller.add(List.from(currentOrders));
      },
    );

    // 2- الاشتراك في التغييرات
    _supabaseService.supabaseClient
        .channel('orders-changes')
        .onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'orders',
      callback: (payload) {
        final order = OrderDm.fromJson(payload.newRecord).toEntity();
        if (order.serviceType.name == 'public') {
          currentOrders.insert(0, order);
          controller.add(List.from(currentOrders));
        }
      },
    )
        .onPostgresChanges(
      event: PostgresChangeEvent.delete,
      schema: 'public',
      table: 'orders',
      callback: (payload) {
        final deletedId = payload.oldRecord['id'] as String;
        currentOrders.removeWhere((o) => o.id == deletedId);
        controller.add(List.from(currentOrders));
      },
    )
        .subscribe();

    yield* controller.stream;
  }


}