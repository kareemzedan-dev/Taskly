import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/errors/failures.dart';

import 'package:taskly/features/auth/presentation/cubit/auth_states.dart';

import '../../domain/use_cases/auth/auth_use_case.dart';

@injectable
class AuthViewModel extends Cubit<AuthStates> {
  AuthViewModel({required this.authUseCase})
    : super(AuthRegisterInitialState());
  AuthUseCase authUseCase;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode? autovalidateMode = AutovalidateMode.disabled;
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController fNameController = TextEditingController();

  final TextEditingController lNameController = TextEditingController();

  void registerUser({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? role,
  }) async {
    try {
      emit(AuthRegisterLoadingState());
      final result = await authUseCase.callRegister(
        firstName!,
        lastName!,
        email!,
        password!,
        role!,
      );
      result.fold((failure) => emit(AuthRegisterErrorState(failure)), (
        registerResponse,
      ) {
        emit(AuthRegisterSuccessState(registerResponse));
      });
    } catch (e) {
      emit(AuthRegisterErrorState(ServerFailure(e.toString())));
    }
  }

  void loginUser({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      emit(AuthLoginLoadingState());
      final result = await authUseCase.callLogin(email, password, role);
      result.fold(
        (failure) => emit(AuthLoginErrorState(failure)),
        (user) => emit(AuthLoginSuccessState(user)),
      );
    } catch (e) {
      emit(AuthLoginErrorState(ServerFailure(e.toString())));
    }
  }
  void googleLogin({required String role}) async {
    try {
      emit(AuthGoogleLoadingState());
      final result = await authUseCase.callGoogleLogin(role);
      result.fold(
              (failure) => emit(AuthGoogleErrorState(failure)),

              (googleResponse) => emit(AuthGoogleSuccessState(googleResponse)));
    }catch(e){
      emit(AuthGoogleErrorState( ServerFailure(e.toString())));

    }
  }
}
