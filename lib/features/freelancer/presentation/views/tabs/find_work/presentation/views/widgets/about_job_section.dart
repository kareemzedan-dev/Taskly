
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/freelancer_work_card.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';

class AboutJobSection extends StatelessWidget {
  const AboutJobSection({super.key , required this.order});
  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About on this job",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                color: Colors.black,
              ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Text(
              "Project Duration",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    color: Colors.grey.shade800,
                  ),
            ),
            const Spacer(),
            Text(
              order.deadline?.toRelative() ?? "",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    color: Colors.grey.shade800,
                  ),
            ),
          ],
        ),

        SizedBox(height: 16.h),
      ],
    );
  }
}