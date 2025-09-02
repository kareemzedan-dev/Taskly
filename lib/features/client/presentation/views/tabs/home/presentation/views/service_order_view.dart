import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/service_order_view_body.dart';

class ServiceOrderView extends StatelessWidget {
  const ServiceOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      backgroundColor: Colors.white,
      body: ServiceOrderViewBody(),
    );
  }
}