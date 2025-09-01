import 'package:flutter/material.dart';
import 'package:taskly/features/auth/presentation/views/widgets/register_view_body.dart';

class RegisterView extends StatelessWidget {
    RegisterView({super.key,required this.role});
   final  String role ;


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
 
      body: SafeArea(child: RegisterViewBody(role: role,)),
    );
  }
}