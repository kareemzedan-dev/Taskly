import 'dart:convert';

import 'package:either_dart/src/either.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/core/services/supabase_service.dart';
import 'package:taskly/features/profile/data/data_sources/profile_remote_data_source.dart';

import '../../domain/entities/user_info_entity/user_info_entity.dart';
import '../models/user_info_dm/user_info_response_dm.dart';
@Injectable(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl extends ProfileRemoteDataSource{
    final SupabaseClient supabase;
  SupabaseService supabaseService = SupabaseService();

  ProfileRemoteDataSourceImpl(this.supabase);

    @override
    Future<Either<Failures, UserInfoDm>> getUserInfo(
        String userId,
        String role,
        ) async {
      try {

        if (userId == null) {
          return Left(ServerFailure("User not logged in"));
        }

        final userResponse = await supabase
            .from('users')
            .select()
            .eq('id', userId )
            .maybeSingle();

        Map<String, dynamic>? extraResponse;

        if (role == "client") {
          extraResponse = await supabase
              .from('clients')
              .select()
              .eq('id', userId)
              .maybeSingle();
        } else if (role == "freelancer") {
          extraResponse = await supabase
              .from('freelancers')
              .select()
              .eq('id', userId)
              .maybeSingle();
        }


        final user = UserInfoDm(
          id: userResponse!['id'],
          fullName: userResponse['full_name'],
          email: userResponse['email'],
          phoneNumber: userResponse['phone_number'],
          role: userResponse['role'],
          profileImage: userResponse['profile_image'],
          bio: userResponse['bio'],
          createdAt: userResponse['created_at'] != null
              ? DateTime.parse(userResponse['created_at'])
              : null,
          rating: userResponse['rating'] != null
              ? (userResponse['rating'] as num).toDouble()
              : null,



          billingInfo: role == "client" && extraResponse?['billing_info'] != null
              ? BillingInfo.fromJson(jsonDecode(extraResponse!['billing_info']))
              : null,

          balance: role == "client"
              ? (extraResponse != null ? extraResponse['balance'] : null)
              : null,



          skills: role == "freelancer" && extraResponse?['skills'] != null
              ? List<String>.from(extraResponse?['skills'])
              : null,
          hourlyRate: role == "freelancer" && extraResponse?['hourly_rate'] != null
              ? (extraResponse?['hourly_rate'] as num).toDouble()
              : null,

        );

        return Right(user);
      } catch (e) {
        return Left(ServerFailure("Failed to fetch user info: $e"));
      }
    }


}