import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/core/services/supabase_service.dart';
import 'package:taskly/features/client/domain/entities/home/service_response_entity.dart';
import 'package:taskly/features/profile/data/models/user_info_dm/user_info_response_dm.dart';
import 'package:taskly/features/profile/domain/entities/user_info_entity/user_info_entity.dart';
import 'package:taskly/features/shared/data/models/order_dm/order_dm.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/client/data/data_sources/remote/home_remote_data_source.dart';
import 'package:taskly/features/client/data/models/home/service_response_dm.dart';
 

@Injectable(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl extends HomeRemoteDataSource {
  final SupabaseClient supabase;
  SupabaseService supabaseService = SupabaseService();

  HomeRemoteDataSourceImpl({required this.supabase});
 

  @override
  Future<Either<Failures, List<ServiceEntity>>> getServices() async {
    try {
      var result = await Connectivity().checkConnectivity();

      if (result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile)) {
        final response = await supabaseService.getDataFromSupabase(
          tableName: "services",
        );

        if (response == null || response.isEmpty) {
          return Left(ServerFailure("Services not found"));
        }

        final services = response.map((e) => ServiceDm.fromJson(e)).toList();

        return Right(services);
      } else {
        return Left(NetworkFailure('No internet connection'));
      }
    } catch (e) {
      return Left(ServerFailure("Failed to fetch services: $e"));
    }
  }

  @override
  Future<Either<Failures, OrderDm>> placeOrder(OrderEntity orderEntity) async {
    try {
      var result = await Connectivity().checkConnectivity();
      if (result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile)) {
        final orderDm = OrderDm.fromEntity(orderEntity);

        final response = await supabaseService.sendDataToSupabase(
          tableName: "orders",
          data: orderDm.toJson(),
        );
        var order = OrderDm.fromJson(response!);
        return Right(order);
      } else {
        return Left(NetworkFailure('No internet connection'));
      }
    } catch (e) {
      return Left(ServerFailure("Failed to place order: $e"));
    }
  }

  @override
  Future<Either<Failures, List<UserInfoEntity>>>
  getAllFreelancerInfo() async {
    try {
      var result = await Connectivity().checkConnectivity();
      if (result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile)) {

        final userResponse = await supabaseService.getDataFromSupabase(
          tableName: "users",
          filters: {"role": "freelancer"},
        );

        if (userResponse == null || userResponse.isEmpty) {
          return Left(ServerFailure("No freelancers found"));
        }


        List<UserInfoEntity> freelancers = [];
        for (final userData in userResponse) {
          final freelancerResponse = await supabaseService.getDataFromSupabase(
            tableName: "freelancers",
            filters: {"id": userData['id']},
          );

          final freelancerData =
              freelancerResponse != null && freelancerResponse.isNotEmpty
                  ? freelancerResponse.first
                  : null;

          final freelancer = UserInfoDm.fromJson(userData);

          final mergedFreelancer = freelancer.copyWith(
            rating: (freelancerData?['rating'] as num?)?.toDouble() ?? 0.0,
            hourlyRate: (freelancerData?['hourly_rate'] as num?)?.toDouble(),
            skills: freelancerData?['skills'] != null
                ? List<String>.from(freelancerData!['skills'])
                : [],

          );

          freelancers.add(mergedFreelancer);
        }

        return Right(freelancers);
      } else {
        return Left(NetworkFailure('No internet connection'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

 

}
