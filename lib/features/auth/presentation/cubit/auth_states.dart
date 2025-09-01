import 'package:taskly/domain/entities/login_response_entity/login_response_entity.dart';
import 'package:taskly/domain/entities/register_response_entity/register_response_entity.dart';

class AuthStates {}

class AuthRegisterInitialState extends AuthStates {}

class AuthRegisterLoadingState extends AuthStates {}

class AuthRegisterSuccessState extends AuthStates {
  final RegisterResponseEntity user;

  AuthRegisterSuccessState(this.user);
}

class AuthRegisterErrorState extends AuthStates {
  final String error;

  AuthRegisterErrorState(this.error);
}

class AuthLoginInitialState extends AuthStates {}

class AuthLoginLoadingState extends AuthStates {}

class AuthLoginSuccessState extends AuthStates {
  final LoginResponseEntity user;
  AuthLoginSuccessState(this.user);
}

class AuthLoginErrorState extends AuthStates {
  final String error;
  AuthLoginErrorState(this.error);
}
