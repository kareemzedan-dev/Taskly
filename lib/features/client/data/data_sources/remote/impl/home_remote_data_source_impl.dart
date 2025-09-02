import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/helper/failures.dart';
import 'package:taskly/core/services/supabase_service.dart';
import 'package:taskly/features/client/data/data_sources/remote/home_remote_data_source.dart';
import 'package:taskly/features/client/data/models/home/service_response_dm.dart';
import 'package:taskly/features/client/data/models/home/user_info_response_dm.dart';
import 'package:taskly/features/client/domain/entities/home/service_response_entity.dart';
import 'package:taskly/features/client/domain/entities/home/user_info_entity.dart';
@Injectable(as:HomeRemoteDataSource )
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

      final response = await supabase
          .from('users')
          .select()
          .eq('id', currentUser.id)
          .single();  

      if (response == null) {
        return Left(ServerFailure("User data not found"));
      }

       
      final user = UserInfoDm(
        id: response['id'],
        fullName: response['full_name'],
        email: response['email'],
        phoneNumber: response['phone_number'],
        role: response['role'],
        profileImage: response['profile_image'],
        bio: response['bio'],
        skills: response['skills'] != null
            ? List<String>.from(response['skills'])
            : null,
        hourlyRate: response['hourly_rate'] != null
            ? (response['hourly_rate'] as num).toDouble()
            : null,
        createdAt: response['created_at'] != null
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

    if (result.contains(ConnectivityResult.wifi) || result.contains(ConnectivityResult.mobile)) {
      final response = await supabaseService.getDataFromSupabase(tableName: "services");

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

}
