import 'package:flutter/material.dart';
import 'package:taskly/features/auth/presentation/views/widgets/login_view_body.dart';

class LoginView extends StatelessWidget {
    LoginView({super.key, required this.role});
    final String role;

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: SafeArea(child: LoginViewBody(role: role,)),
    );
  }
}