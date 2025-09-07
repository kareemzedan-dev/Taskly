import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/helper/failures.dart';
import 'package:taskly/core/services/supabase_service.dart';
import 'package:taskly/features/client/data/data_sources/remote/home_remote_data_source.dart';
import 'package:taskly/features/client/data/models/home/freelancer_dm.dart';
import 'package:taskly/features/client/data/models/home/order_dm.dart';
import 'package:taskly/features/client/data/models/home/service_response_dm.dart';
import 'package:taskly/features/client/data/models/home/user_info_response_dm.dart';
import 'package:taskly/features/client/domain/entities/home/freelancer_entity.dart';
import 'package:taskly/features/client/domain/entities/home/order_entity.dart';
import 'package:taskly/features/client/domain/entities/home/service_response_entity.dart';

@Injectable(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl extends HomeRemoteDataSource {
  final SupabaseClient supabase;
  SupabaseService supabaseService = SupabaseService();

  HomeRemoteDataSourceImpl({required this.supabase});

  @override
  Future<Either<Failures, UserInfoDm>> getUserInfo() async {
    try {
      final currentUser = supabase.auth.currentUser;

      if (currentUser == null) {
        return Left(ServerFailure("User not logged in"));
      }

      final response =
          await supabase
              .from('users')
              .select()
              .eq('id', currentUser.id)
              .single();

      final user = UserInfoDm(
        id: response['id'],
        fullName: response['full_name'],
        email: response['email'],
        phoneNumber: response['phone_number'],
        role: response['role'],
        profileImage: response['profile_image'],
        bio: response['bio'],
        skills:
            response['skills'] != null
                ? List<String>.from(response['skills'])
                : null,
        hourlyRate:
            response['hourly_rate'] != null
                ? (response['hourly_rate'] as num).toDouble()
                : null,
        createdAt:
            response['created_at'] != null
                ? DateTime.parse(response['created_at'])
                : null,
      );

      return Right(user);
    } catch (e) {
      return Left(ServerFailure("Failed to fetch user info: $e"));
    }
  }

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
  Future<Either<Failures, List<FreelancerEntity>>>
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

     
        List<FreelancerEntity> freelancers = [];
        for (final userData in userResponse) {
          final freelancerResponse = await supabaseService.getDataFromSupabase(
            tableName: "freelancers",
            filters: {"id": userData['id']},
          );

          final freelancerData =
              freelancerResponse != null && freelancerResponse.isNotEmpty
                  ? freelancerResponse.first
                  : null;

          final freelancer = FreelancerDm.fromJson(userData);

          final mergedFreelancer = freelancer.copyWith(
            rating: freelancerData?['rating'] ?? 0.0,
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
