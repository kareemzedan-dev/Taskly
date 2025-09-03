import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/service_order_view_body.dart';

class ServiceOrderView extends StatelessWidget {
  const ServiceOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(CupertinoIcons.back, color: Colors.black)),
        title: Text(
          'Service Order',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        shape: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 2),
        ),
      ),

      backgroundColor: Colors.white,
      body: ServiceOrderViewBody(),
    );
  }
}
