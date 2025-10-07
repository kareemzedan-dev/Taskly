import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/core/services/supabase_service.dart';
import 'package:taskly/features/messages/data/data_sources/remote/get_accepted_order_message_remote_data_source/get_accepted_order_message_remote_data_source.dart';
import 'package:taskly/features/shared/data/models/order_dm/order_dm.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/welcome/presentation/cubit/welcome_states.dart';

@Injectable(as: GetAcceptedOrderMessageRemoteDataSource)
class GetAcceptedOrderMessageRemoteDataSourceImpl
    extends GetAcceptedOrderMessageRemoteDataSource {
  final SupabaseService supabaseService;

  GetAcceptedOrderMessageRemoteDataSourceImpl({required this.supabaseService});

  @override
  Future<Either<Failures, List<OrderEntity>>> getAcceptedOrderMessages(
      String userId,
      {UserRole? role}) async {
    try {
      Map<String, dynamic> filters = {};
      String? or;

      if (role != null) {
        final column =
            role == UserRole.freelancer ? 'freelancer_id' : 'client_id';
        filters[column] = userId;

        or =
            'status.eq.Accepted,status.eq.Paid,status.eq.In Progress,status.eq.Completed,status.eq.Waiting,status.eq.Cancelled';
      } else {
        filters['client_id'] = userId;
        or =
            'status.eq.Accepted,status.eq.Paid,status.eq.In Progress,status.eq.Waiting,status.eq.Completed,status.eq.Cancelled';
      }

      final response = await supabaseService.getDataFromSupabase(
        tableName: 'orders',
        filters: filters,
        or: or,
      );

      final responseList = response ?? [];
      final data =
          responseList.map((e) => OrderDm.fromJson(e).toEntity()).toList();

      return Right(data);
    } catch (e, st) {
      print("Error fetching accepted messages: $e");
      print(st);
      return Left(ServerFailure(e.toString()));
    }
  }
}
