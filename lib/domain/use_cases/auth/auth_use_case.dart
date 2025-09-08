import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
 
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/domain/entities/login_response_entity/login_response_entity.dart';
import 'package:taskly/domain/entities/register_response_entity/register_response_entity.dart';
import 'package:taskly/domain/repos/auth/auth_repo.dart';

 @injectable
class AuthUseCase {
  AuthRepo authRepo;

  AuthUseCase(this.authRepo);

  Future<Either<Failures, RegisterResponseEntity>> callRegister(
    String firstName,
    String lastName,
    String email,
    String password,
    String role
  ) => authRepo.register(firstName, lastName, email, password, role);
  
   Future<Either<Failures, LoginResponseEntity>> callLogin(
    String email,
    String password,
    String role
  ) => authRepo.login(email, password,role);
}
