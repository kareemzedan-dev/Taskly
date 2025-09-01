import 'package:either_dart/either.dart';
import 'package:taskly/core/helper/failures.dart';
import 'package:taskly/domain/entities/login_response_entity/login_response_entity.dart';
import 'package:taskly/domain/entities/register_response_entity/register_response_entity.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failures, RegisterResponseEntity>> register(
    String firstName,
    String lastName,
    String email,
    String password,
    String role,
  );

  Future<Either<Failures, LoginResponseEntity>> login(String email, String password, String role);
}
