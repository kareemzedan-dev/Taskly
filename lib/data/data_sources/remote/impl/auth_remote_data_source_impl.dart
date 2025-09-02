import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:either_dart/src/either.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/helper/failures.dart';
import 'package:taskly/core/helper/shared_preferences.dart';
import 'package:taskly/core/services/supabase_service.dart';
import 'package:taskly/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:taskly/data/models/login_response_dm/login_response_dm.dart';
import 'package:taskly/data/models/register_response_dm/register_response_dm.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final SupabaseClient supabase = Supabase.instance.client;
  SupabaseService supabaseService = SupabaseService();

  @override
  Future<Either<Failures, RegisterResponseDm>> register(
    String firstName,
    String lastName,
    String email,
    String password,
    String role,
  ) async {
    try {
      List<ConnectivityResult> result =
          await Connectivity().checkConnectivity();
      if (result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile)) {
        final response = await supabase.auth.signUp(
          email: email,
          password: password,
          data: {'first_name': firstName, 'last_name': lastName, 'role': role},
        );

        if (response.user != null && response.session == null) {
          return Left(
            ServerFailure(
              "Email already exists or not confirmed. Please check your email.",
            ),
          );
        }

        final user = response.user;
        final token = response.session?.accessToken;

        final userDm = UserDm(
          firstName: firstName,
          lastName: lastName,
          email: user!.email,
          password: password,
          role: role,
        );

        if (token != null) {
          await SharedPrefHelper.setString('token', token);
          await SharedPrefHelper.setString('id', user.id);
          await SharedPrefHelper.setString('fullName', "$firstName $lastName");
          await SharedPrefHelper.setString('email', email);
          await SharedPrefHelper.setString('role', role);
        }

        final registerResponse = RegisterResponseDm(
          user: userDm,
          message: "User registered successfully",
          token: token,
        );
        Map<String, dynamic>? success = await supabaseService
            .sendDataToSupabase(
              tableName: 'users',
              data: {
                'id': user.id,
                'full_name': "$firstName $lastName",
                'email': user.email,
                'role': role,
              },
              conflictColumn: 'email',
            );
        bool successResult = (success != null);

        if (successResult) {
          print('User saved successfully!');
        } else {
          print('Failed to save user.');
        }

        return Right(registerResponse);
      } else {
        return Left(NetworkFailure('No internet connection'));
      }
    } on AuthException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      debugPrint("Error: $e\n$stackTrace");
      return Left(ServerFailure("Something went wrong, please try again"));
    }
  }

  @override
  Future<Either<Failures, LoginResponseDm>> login(
    String email,
    String password,
    String role,
  ) async {
    try {
      List<ConnectivityResult> result =
          await Connectivity().checkConnectivity();
      if (!(result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile))) {
        return Left(NetworkFailure('No internet connection'));
      }

      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      final session = response.session;
      final token = session?.accessToken;
      if (user == null || session == null) {
        return Left(
          ServerFailure("Login failed. Please check your email and password."),
        );
      }

      final userRole = user.userMetadata!['role'] ?? '';
      if (userRole != role) {
        return Left(
          ServerFailure(
            "You are not registered as a $role. Please use the correct account.",
          ),
        );
      }

      if (token != null) {
        await SharedPrefHelper.setString('token', token);
        await SharedPrefHelper.setString('id', user.id);
        await SharedPrefHelper.setString(
          'fullName',
          user.userMetadata!['full_name'],
        );
        await SharedPrefHelper.setString('email', user.email!);
        await SharedPrefHelper.setString('role', role);
      }

      final userDm = LoginUserDm(email: user.email, password: password);
      final loginResponse = LoginResponseDm(
        user: userDm,
        message: "User Login successfully",
        token: token,
      );
      Map<String, dynamic>? success = await supabaseService.sendDataToSupabase(
        tableName: 'users',
        data: {
          'id': user.id,
          'full_name': user.userMetadata!['full_name'],
          'email': user.email,

          'role': role,
        },
        conflictColumn: 'email',
      );
      bool successResult = (success != null);

      if (successResult) {
        print('User saved successfully!');
      } else {
        print('Failed to save user.');
      }
      return Right(loginResponse);
    } on AuthException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      debugPrint("Error: $e\n$stackTrace");
      return Left(ServerFailure("Something went wrong, please try again"));
    }
  }
}
