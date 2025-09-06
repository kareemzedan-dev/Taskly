import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/model_bottom_sheet_content.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/order_action_button.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/order_header.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/order_progress_time_line.dart';

class OrderStatesCard extends StatelessWidget {
  const OrderStatesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const OrderHeader(
                orderName: "Order Name",
                orderId: "#343432",
              ),

              SizedBox(height: 20.h),

              OrderProgressTimeline(
                steps: ['Created', 'Paid', 'Executing', 'Completed'],
                currentStep: 0,
              ),
              SizedBox(height: 26.h),

              OrderActionButton(
                text: "Offers You’ve Received",
                icon: Icons.local_offer_outlined,
                color: ColorsManager.primary,
                count: 3,
                onTap: () {},
              ),

              SizedBox(height: 10.h),

              OrderActionButton(
                text: "View details",
                icon: Icons.remove_red_eye_outlined,
                color: ColorsManager.primary,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) {
                      return ModelBottomSheetContent();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

  