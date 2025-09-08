import 'package:either_dart/src/either.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/core/services/supabase_service.dart';
import 'package:taskly/data/data_sources/remote/profile_remote_data_source.dart';
import 'package:taskly/data/models/user_info_dm/user_info_response_dm.dart';
import 'package:taskly/domain/entities/user_info_entity/user_info_entity.dart';
@Injectable(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl extends ProfileRemoteDataSource{
    final SupabaseClient supabase;
  SupabaseService supabaseService = SupabaseService();

  ProfileRemoteDataSourceImpl(this.supabase);


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

}