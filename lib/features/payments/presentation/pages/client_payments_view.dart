import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/domain/entities/order_entity/order_entity.dart';
import '../../../shared/presentation/views/widgets/custom_app_bar.dart';
import '../widgets/client_payments_view_body.dart';

class ClientPaymentsView extends StatelessWidget {
  const ClientPaymentsView({super.key, required this.order});
  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
    body:   ClientPaymentsViewBody(order:order),
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      title:   Text('Payments',style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 18.sp,
      )),
      surfaceTintColor: Colors.white,
      elevation: 0,
      bottom:  PreferredSize(preferredSize:Size(double.infinity, 1.h) , child: Divider(thickness: 1,color: Colors.grey.shade300,)),
        leading: IconButton(
    icon: Icon(CupertinoIcons.arrow_left, color: Colors.black),
      onPressed: () => Navigator.pop(context),
    ),


    ));
  }
}
