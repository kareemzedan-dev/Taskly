import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/job_details_view_body.dart';

class JobDetailsView extends StatelessWidget {
  const JobDetailsView({super.key, required this.orderEntity});
  final OrderEntity orderEntity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         surfaceTintColor: Colors.transparent, 
        backgroundColor: Colors.white,
        title: Text(
          'Job Details',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(CupertinoIcons.back, color: Colors.black)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade300, height: 1.0),
        ),
      ),
      backgroundColor: Colors.white,
      body: JobDetailsViewBody(orderEntity:orderEntity ,),
    );
  }
}
