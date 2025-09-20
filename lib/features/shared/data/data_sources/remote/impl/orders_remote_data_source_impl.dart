
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:either_dart/src/either.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/core/services/supabase_service.dart';
import 'package:taskly/features/shared/data/data_sources/remote/orders_remote_data_source.dart';
import 'package:taskly/features/shared/data/models/order_dm/order_dm.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';

@Injectable(as: OrdersRemoteDataSource)
class OrdersRemoteDataSourceImpl extends OrdersRemoteDataSource {
  final SupabaseService supabaseService = SupabaseService();
  RealtimeChannel? _ordersChannel;

  @override
  Future<Either<Failures, List<OrderEntity>>> getUserOrdersByUserId(
      String userId,
      String role,
      ) async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return Left(Failures("No internet connection"));
      }

      String fieldName;
      if (role.toLowerCase() == 'client') {
        fieldName = "client_id";
      } else if (role.toLowerCase() == 'freelancer') {
        fieldName = "freelancer_id";
      } else {
        return Left(Failures("Invalid role provided"));
      }

      _ordersChannel ??= supabaseService.subscribe(
        table: 'orders',
        filters: { fieldName: userId },
        onChange: (record, action) {
          final order = OrderDm.fromJson(record);
          print('Order ${order.id} updated. Status: ${order.status}');

        },
      );


      final response = await supabaseService.getDataFromSupabase(
        tableName: "orders",
        filters: {fieldName: userId},
      );

      if (response == null || response.isEmpty) {
        return Right([]);
      }

      final orders = response.map((e) => OrderDm.fromJson(e).toEntity()).toList();
      return Right(orders);
    } catch (e) {
      return Left(Failures(e.toString()));
    }
  }

  void unsubscribe() {
    if (_ordersChannel != null) {
      supabaseService.unsubscribe(table: 'orders');
      _ordersChannel = null;
    }
  }
}
