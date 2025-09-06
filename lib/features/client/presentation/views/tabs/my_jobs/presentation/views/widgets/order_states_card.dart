import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/order_progress_time_line.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/state_bage.dart';

class OrderStatesCard extends StatelessWidget {
  const OrderStatesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
        width: double.infinity,
        height: 100.h,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Order Name',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Spacer(),
                  StatusBadge(
                    text: "Pending",
                    color: ColorsManager.primary,
                    icon: Icons.pending_actions_outlined,
                  ),
                  SizedBox(width: 5.w),
                  StatusBadge(
                    text: "delete",
                    color: Colors.red,
                    icon: Icons.delete,
                  ),
                ],
              ),

              SizedBox(height: 5.h),
              OrderProgressTimeline(
                steps: ['Created', 'Paid', 'Completed'],
                currentStep: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
