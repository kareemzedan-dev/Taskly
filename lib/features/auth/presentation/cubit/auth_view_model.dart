import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'package:taskly/domain/use_cases/auth/auth_use_case.dart';
import 'package:taskly/features/auth/presentation/cubit/auth_states.dart';

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
      result.fold((failure) => emit(AuthRegisterErrorState(failure.message)), (
        registerResponse,
      ) {
        emit(AuthRegisterSuccessState(registerResponse));
      });
    } catch (e) {
      emit(AuthRegisterErrorState(e.toString()));
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
        (failure) => emit(AuthLoginErrorState(failure.message)),
        (user) => emit(AuthLoginSuccessState(user)),
      );
    } catch (e) {
      emit(AuthLoginErrorState(e.toString()));
    }
  }
}
