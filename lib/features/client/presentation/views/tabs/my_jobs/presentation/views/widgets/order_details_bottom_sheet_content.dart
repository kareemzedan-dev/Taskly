import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/helper/date_time_formatter.dart';
import 'package:taskly/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/shared/presentation/views/widgets/attachments_section.dart';
import 'package:taskly/features/shared/presentation/views/widgets/description_section.dart';
import 'package:taskly/features/shared/presentation/views/widgets/job_header_section.dart';

class OrderDetailsBottomSheetContent extends StatelessWidget {
  OrderDetailsBottomSheetContent({super.key, required this.order});
  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              JobHeader(
                title: order.title,
                category: order.category ?? "No category",
                date: order.deadline?.toRelative() ?? "No deadline",
              ),

              SizedBox(height: 16.h),

              DescriptionSection(description: order.description),
              SizedBox(height: 16.h),
              AttachmentsSection(),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
