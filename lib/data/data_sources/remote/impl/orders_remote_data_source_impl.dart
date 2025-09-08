import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:either_dart/src/either.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/data/data_sources/remote/orders_remote_data_source.dart';
import 'package:taskly/data/models/order_dm/order_dm.dart';
import 'package:taskly/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/order_view_body.dart';
@Injectable(as: OrdersRemoteDataSource)
class OrdersRemoteDataSourceImpl extends OrdersRemoteDataSource {
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

    
      final response = await supabaseService.getDataFromSupabase(
        tableName: "orders",
        filters: {fieldName: userId},
      );

      if (response == null || response.isEmpty) {
        return  Right([]);
      }

 
      final orders = response
          .map((e) => OrderDm.fromJson(e).toEntity())
          .toList();

      return Right(orders);
    } catch (e) {
      return Left(Failures(e.toString()));
    }
  }
}
