import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:either_dart/src/either.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/config/l10n/app_localizations.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/core/cache/shared_preferences.dart';
import 'package:taskly/core/services/supabase_service.dart';
import 'package:taskly/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/utils/constants_manager.dart';
import '../../../../../core/utils/network_utils.dart';
import '../../../../../core/utils/strings_manager.dart';
import '../../../domain/entities/google_response_entity/google_response_entity.dart';
import '../../models/google_response_dm/google_response_dm.dart';
import '../../models/login_response_dm/login_response_dm.dart';
import '../../models/register_response_dm/register_response_dm.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final SupabaseClient supabase = Supabase.instance.client;
  final SupabaseService supabaseService = SupabaseService();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: ConstantsManager.supabaseServerClientId,
    scopes: ['email', 'profile'],
  );

  Future<void> _saveUserLocally({
    required String token,
    required String id,
    required String fullName,
    required String email,
    required String role,
  }) async {
    await SharedPrefHelper.setString(StringsManager.tokenKey, token);
    await SharedPrefHelper.setString(StringsManager.idKey, id);
    await SharedPrefHelper.setString(StringsManager.fullNameKey, fullName);
    await SharedPrefHelper.setString(StringsManager.emailKey, email);
    await SharedPrefHelper.setString(StringsManager.roleKey, role);
  }
Future<void> _saveUserToSupabase({
  required String id,
  required String fullName,
  required String email,
  required String role,
  String? avatarUrl,
}) async {
  final existingUser = await supabase
      .from('users')
      .select()
      .eq('id', id)
      .maybeSingle();

  if (existingUser == null) {
    await supabaseService.sendDataToSupabase(
      tableName: 'users',
      data: {
        'id': id,
        'full_name': fullName,
        'email': email,
        'role': role,
        'profile_image': avatarUrl,
        'rating': 0.0,
        'jobs_count': 0,
        'reviews_count': 0,
      },
      conflictColumn: 'email',
    );
  }
}


Future<void> _insertRoleData(String id, String role) async {
  final now = DateTime.now().toIso8601String();

  if (role == StringsManager.clientRole) {
 
    final existingClient = await supabase
        .from('clients')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (existingClient == null) {
      await supabaseService.sendDataToSupabase(
        tableName: 'clients',
        data: {
          'id': id,
          'billing_info': '',
          'balance': 0,
          'created_at': now,
        },
        conflictColumn: 'id',
      );
    }
  } else if (role == StringsManager.freelancerRole) {
 
    final existingFreelancer = await supabase
        .from('freelancers')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (existingFreelancer == null) {
      await supabaseService.sendDataToSupabase(
        tableName: 'freelancers',
        data: {
          'id': id,
          'is_verified': false,
          'freelancer_status': 'Active',
          'freelancer_balance': 0.0,
          'created_at': now,
        },
        conflictColumn: 'id',
      );
    }
  }
}


  Future<void> _handleUserAfterAuth({
    required String id,
    required String fullName,
    required String email,
    required String token,
    required String role,
    String? avatarUrl,
  }) async {
    await _saveUserLocally(
      id: id,
      fullName: fullName,
      email: email,
      token: token,
      role: role,
    );
    await _saveUserToSupabase(
      id: id,
      fullName: fullName,
      email: email,
      role: role,
      avatarUrl: avatarUrl,
    );
    await _insertRoleData(id, role);
  }

  @override
  Future<Either<Failures, RegisterResponseDm>> register(
    String firstName,
    String lastName,
    String email,
    String password,
    String role,
  ) async {
    try {
      if (!await NetworkUtils.hasInternet())
        return Left(NetworkFailure(StringsManager.noInternetConnection));

      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'first_name': firstName, 'last_name': lastName, 'role': role},
      );

      if (response.user != null && response.session == null) {
        return Left(ServerFailure(StringsManager.emailAlreadyExists));
      }

      final user = response.user!;
      final token = response.session?.accessToken ?? '';

      final userDm = UserDm(
        firstName: firstName,
        lastName: lastName,
        email: user.email,
        password: password,
        role: role,
      );

      await _handleUserAfterAuth(
        id: user.id,
        fullName: "$firstName $lastName",
        email: user.email!,
        token: token,
        role: role,
      );

      final registerResponse = RegisterResponseDm(
        user: userDm,
        message: StringsManager.userRegisteredSuccessfully,
        token: token,
      );

      return Right(registerResponse);
    } on AuthException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      debugPrint("Error: $e\n$stackTrace");
      return Left(ServerFailure(StringsManager.somethingWentWrong));
    }
  }

  @override
  Future<Either<Failures, LoginResponseDm>> login(
    String email,
    String password,
    String role,
  ) async {
    try {
      if (!await NetworkUtils.hasInternet())
        return Left(NetworkFailure(StringsManager.noInternetConnection));

      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      final session = response.session;
      final token = session?.accessToken;

      if (user == null || session == null) {
        return Left(ServerFailure(StringsManager.loginFailed));
      }

      final userRole = user.userMetadata?['role'] ?? '';
      if (userRole != role) {
        return Left(
          ServerFailure(
            StringsManager.notRegisteredAsRole,
            params: {"role": role},
          ),
        );
      }

      final userData =
          await supabase.from('users').select().eq('id', user.id).maybeSingle();
      final fullName = userData?['full_name'] ?? '';

      await _handleUserAfterAuth(
        id: user.id,
        fullName: fullName,
        email: user.email ?? '',
        token: token ?? '',
        role: role,
      );

      final userDm = LoginUserDm(email: user.email, password: password);
      final loginResponse = LoginResponseDm(
        user: userDm,
        message: StringsManager.userLoginSuccessfully,
        token: token,
      );

      return Right(loginResponse);
    } on AuthException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      debugPrint("Error: $e\n$stackTrace");
      return Left(ServerFailure(StringsManager.somethingWentWrong));
    }
  }

  @override
  Future<Either<Failures, GoogleAuthResponseEntity>> googleLogin(
    String role,
  ) async {
    try {
      if (!await NetworkUtils.hasInternet()) {
        return Left(NetworkFailure(StringsManager.noInternetConnection));
      }

      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        return Left(ServerFailure(StringsManager.googleLoginCancelled));
      }

      final GoogleSignInAuthentication googleAuth =
          await account.authentication;

      final res = await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );

      if (res.user == null || res.session == null) {
        return Left(ServerFailure(StringsManager.loginFailed));
      }

      final supabaseUser = res.user!;
      final supabaseToken = res.session!.accessToken;

      final email = account.email;
      final fullName = account.displayName ?? '';
      final avatarUrl = account.photoUrl;

      final existingUser =
          await supabase
              .from('users')
              .select()
              .eq('email', email)
              .maybeSingle();
      if (existingUser != null && existingUser['role'] != role) {
        return Left(
          ServerFailure(
            StringsManager.accountAlreadyRegistered,
            params: {"existingRole": existingUser['role'], "role": role},
          ),
        );
      }

      final userId =
          existingUser != null ? existingUser['id'] : supabaseUser.id;

      await _handleUserAfterAuth(
        id: userId,
        fullName: fullName,
        email: email,
        token: supabaseToken,
        role: role,
        avatarUrl: avatarUrl,
      );

      final googleUser = GoogleUserDm(
        id: userId,
        name: fullName,
        email: email,
        role: role,
        avatarUrl: avatarUrl,
      );

      final googleResponse = GoogleAuthResponseDm(
        token: supabaseToken,
        user: googleUser,
        message: StringsManager.googleLoginSuccessful,
      );

      return Right(googleResponse);
    } catch (e, stackTrace) {
      debugPrint("Error: $e\n$stackTrace");
      return Left(ServerFailure(StringsManager.somethingWentWrong));
    }
  }
}
