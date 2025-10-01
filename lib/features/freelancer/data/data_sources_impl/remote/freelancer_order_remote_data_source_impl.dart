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
  }
  @override
  Stream<List<OrderEntity>> subscribeToPendingOrders(String freelancerId) {
    if (NetworkUtils.hasInternet() == false) {
      throw NetworkFailure('No internet connection');
    }

    // هنا نحدد المفتاح الأساسي
    final stream = _supabaseService.supabaseClient
        .from('orders')
        .stream(primaryKey: ['id']) // مهم جدًا
        .map((records) {
      // جلب الأوردرات اللي الفريلانسر قدم عليها مرة واحدة
      final offersFuture = _supabaseService.supabaseClient
          .from('offers')
          .select('order_id')
          .eq('freelancer_id', freelancerId)
          .then((offersResponse) =>
          (offersResponse as List).map((e) => e['order_id'] as String).toList());

      return offersFuture.then((offeredOrderIds) {
        final orders = records
            .map((e) => OrderDm.fromJson(e).toEntity())
            .where((o) => o.serviceType.name == 'public')
            .where((o) => !offeredOrderIds.contains(o.id))
            .toList();

        return orders;
      });
    }).asyncExpand((futureList) => Stream.fromFuture(futureList));

    return stream;
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
  @override
  Stream<(OrderEntity, String)> subscribeToPrivateOrders(String freelancerId) {
    if (NetworkUtils.hasInternet() == false) {
      throw NetworkFailure('No internet connection');
    }

    return _supabaseService.supabaseClient
        .from('orders')
        .stream(primaryKey: ['id'])
        .asyncExpand((records) async* {
      // فلترة الأوردرات الخاصة
      final filtered = records
          .map((json) => OrderDm.fromJson(json).toEntity())
          .where((o) =>
      o.serviceType.name == 'private' &&
          o.status.name == 'Pending' &&
          o.freelancerId == freelancerId)
          .toList();

      // جلب الأوردرات اللي الفريلانسر قدم عليها
      final offersResponse = await _supabaseService.supabaseClient
          .from('offers')
          .select('order_id')
          .eq('freelancer_id', freelancerId);

      final offeredOrderIds =
      (offersResponse as List).map((e) => e['order_id'] as String).toList();

      // الأوردرات الجديدة فقط
      final newOrders =
      filtered.where((o) => !offeredOrderIds.contains(o.id)).toList();

      // إرسال كل أوردر مع نوع الحدث (INSERT هنا كمثال)
      for (var order in newOrders) {
        yield (order, "INSERT");
      }
    });
  }


  // باقي الـ methods...
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