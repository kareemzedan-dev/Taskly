import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/attachments_section.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/description_section.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/job_header_section.dart';

class OrderDetailsContent extends StatelessWidget {
  const OrderDetailsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(child: Padding(padding: const EdgeInsets.all(16.0),child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      JobHeader(),
      SizedBox(height: 16.h),
      DescriptionSection(),
      SizedBox(height: 16.h),
      AttachmentsSection(),
      SizedBox(height: 16.h),
    ]
    ,)),);
  }
}