import 'dart:async';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/core/services/supabase_service.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/shared/data/models/order_dm/order_dm.dart';

import '../../../../../welcome/presentation/cubit/welcome_states.dart';
import '../../../data_sources/remote/get_accepted_order_message_remote_data_source/get_accepted_order_message_remote_data_source.dart';
import 'package:rxdart/rxdart.dart';

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
      } else {
        filters['client_id'] = userId;
      }

      or =
      'status.eq.Accepted,status.eq.Paid,status.eq.In Progress,status.eq.Waiting,status.eq.Completed,status.eq.Cancelled';

      final response = await supabaseService.getDataFromSupabase(
        tableName: 'orders',
        filters: filters,
        or: or,
      );

      final responseList = response ?? [];

      final List<OrderEntity> orders = [];

      for (var orderData in responseList) {
        final order = OrderDm.fromJson(orderData).toEntity();

        final lastMsgData = await supabaseService.supabaseClient
            .from('messages')
            .select()
            .eq('order_id', order.id)
            .order('created_at', ascending: false)
            .limit(1)
            .maybeSingle(); // هيرجع Map<String, dynamic>? مباشرة

        if (lastMsgData != null) {
          final lastMessageContent = lastMsgData['content'] as String?;
          final lastMessageTime = DateTime.tryParse(lastMsgData['created_at'] ?? '');
          orders.add(order.copyWith(
            lastMessage: lastMessageContent,
            lastMessageTime: lastMessageTime,
          ));
        } else {
          orders.add(order);
        }

      }

      return Right(orders);
    } catch (e, st) {
      print("Error fetching accepted messages: $e");
      print(st);
      return Left(ServerFailure(e.toString()));
    }
  }

  Stream<List<OrderEntity>> subscribeToAcceptedOrders(String userId, {UserRole? role}) {
    final column = role == UserRole.freelancer ? 'freelancer_id' : 'client_id';
    final statuses = [
      'Accepted', 'Paid', 'In Progress', 'Completed', 'Waiting', 'Cancelled'
    ];

    // Stream الأوردرات
    final ordersStream = supabaseService.supabaseClient
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq(column, userId);

    // Stream الرسائل
    final messagesStream = supabaseService.supabaseClient
        .from('messages')
        .stream(primaryKey: ['id']);

    // دمج الأوردرات مع آخر رسالة
    return Rx.combineLatest2(
        ordersStream,
        messagesStream,
            (List ordersList, List messagesList) {
          final filteredOrders = ordersList
              .where((o) => statuses.contains(o['status']))
              .map((e) => OrderDm.fromJson(e).toEntity())
              .toList();

          return filteredOrders.map((order) {
            final lastMessage = messagesList
                .where((m) => m['order_id'] == order.id)
                .toList()
              ..sort((a, b) => (b['created_at'] as String)
                  .compareTo(a['created_at'] as String));

            if (lastMessage.isNotEmpty) {
              final last = lastMessage.first;
              return order.copyWith(
                lastMessage: last['content'] as String?,
                lastMessageTime: DateTime.tryParse(last['created_at'] ?? ''),
              );
            }

            return order;
          }).toList();
        });
  }


}
