import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:either_dart/src/either.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/helper/failures.dart';
import 'package:taskly/core/helper/shared_preferences.dart';
import 'package:taskly/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:taskly/data/models/login_response_dm/login_response_dm.dart';
import 'package:taskly/data/models/register_response_dm/register_response_dm.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/domain/entities/login_response_entity/login_response_entity.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final SupabaseClient supabase = Supabase.instance.client;

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
          debugPrint("Saved Token: $token");
        }

        final registerResponse = RegisterResponseDm(
          user: userDm,
          message: "User registered successfully",
          token: token,
        );

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

      debugPrint("Login User: $user");
      debugPrint("Login Session: $session");

      if (user == null || session == null) {
        return Left(
          ServerFailure("Login failed. Please check your email and password."),
        );
      }

      // تحقق من الدور (role)
      final userRole = user.userMetadata!['role'] ?? '';
      if (userRole != role) {
        return Left(
          ServerFailure(
            "You are not registered as a $role. Please use the correct account.",
          ),
        );
      }

      // حفظ الـ token
      if (token != null) {
        await SharedPrefHelper.setString('token', token);
        debugPrint("Saved Token: $token");
      }

      final userDm = LoginUserDm(email: user.email, password: password);
      // إنشاء LoginResponseEntity
      final loginResponse = LoginResponseDm(
        user: userDm,
        message: "User Login successfully",
        token: token,
      );

      return Right(loginResponse);
    } on AuthException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      debugPrint("Error: $e\n$stackTrace");
      return Left(ServerFailure("Something went wrong, please try again"));
    }
  }
}
