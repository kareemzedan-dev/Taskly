import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/core/services/supabase_service.dart';
import 'package:taskly/core/utils/network_utils.dart';
import 'package:taskly/features/shared/data/models/order_dm/order_dm.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/freelancer/data/data_sources/remote/freelancer_order_remote_data_source.dart';

@Injectable(as: FreelancerOrderRemoteDataSource)
class FreelancerOrderRemoteDataSourceImpl
    extends FreelancerOrderRemoteDataSource {
  final SupabaseService _supabaseService;

  FreelancerOrderRemoteDataSourceImpl({
    required SupabaseService supabaseService,
  }) : _supabaseService = supabaseService;


  @override
  Future<Either<Failures, List<OrderEntity>>> fetchPendingFreelancerOrders(String freelancerId) async {
    try {
      if (NetworkUtils.hasInternet() == false) {
        return Left(NetworkFailure('No internet connection'));
      }

      // جلب الأوردرات اللي الفريلانسر قدم عليها
      final offersResponse = await _supabaseService.supabaseClient
          .from('offers')
          .select('order_id')
          .eq('freelancer_id', freelancerId);

      final offeredOrderIds = (offersResponse == null || (offersResponse as List).isEmpty)
          ? <String>[]
          : (offersResponse as List).map((e) => e['order_id'] as String).toList();

      // بناء الاستعلام
      var query = _supabaseService.supabaseClient
          .from('orders')
          .select('*')
          .eq('status', 'Pending') // بالظبط زي ما موجودة في قاعدة البيانات
          .eq('service_type', 'public');

      // استبعاد الأوردرات اللي قدم عليها الفريلانسر لو فيه فعلاً
      if (offeredOrderIds.isNotEmpty) {
        query = query.not('id', 'in', offeredOrderIds);
      }

      final response = await query;

      if ((response as List).isEmpty) return Right([]);

      final orders = response
          .map((json) => OrderDm.fromJson(json).toEntity())
          .toList(); // مش هنعمل فلترة إضافية هنا

      return Right(orders);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch pending orders: $e'));
    }
  }Stream<List<OrderEntity>> subscribeToPendingOrders(String freelancerId) async* {
    if (NetworkUtils.hasInternet() == false) {
      throw NetworkFailure('No internet connection');
    }

    final controller = StreamController<List<OrderEntity>>();
    final currentOrders = <OrderEntity>[];

    // 1- تحميل الحالة الأولية
    final initialResult = await fetchPendingFreelancerOrders(freelancerId);
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





  @override
  Future<Either<Failures, List<OrderEntity>>> fetchPrivateOrders(
      String freelancerId) async {
    try {
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.none) {
        return Left(NetworkFailure('No internet connection'));
      }

      final response = await _supabaseService.supabaseClient
          .from('orders')
          .select('*')
          .eq('freelancer_id', freelancerId)
          .eq('service_type', 'private')
          .eq('status', 'Pending');

      if ((response as List).isEmpty) return Right([]);

      final orders = response.map((json) => OrderDm.fromJson(json)).toList();
      return Right(orders);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch private orders: $e'));
    }
  }



  Stream<List<OrderEntity>> subscribeToPrivateOrders(String freelancerId) {
    if (NetworkUtils.hasInternet() == false) {
      throw NetworkFailure('No internet connection');
    }

    final controller = StreamController<List<OrderEntity>>();
    final currentOrders = <OrderEntity>[];

    // 1- جلب الأوردرات الحالية
    fetchPrivateOrders(freelancerId).then((result) {
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


  @override
  Future<Either<Failures, void>> updateOrderStatus(
      String orderId, String status) async {
    try {
      await _supabaseService.supabaseClient
          .from('orders')
          .update({'status': status}).eq('id', orderId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to update order status: $e'));
    }
  }

  @override
  Future<Either<Failures, void>> withdrawOffer(
      String offerId, String orderId) async {
    try {
      await _supabaseService.supabaseClient
          .from('offers')
          .update({'status': 'withdrawn'}).eq('id', offerId);

      await _supabaseService.supabaseClient.rpc(
        'decrement_offers_count',
        params: {'order_id': orderId},
      );

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to withdraw offer: $e'));
    }
  }
}