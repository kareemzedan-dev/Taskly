import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/config/routes/routes_manager.dart';
import 'package:taskly/core/components/custom_button.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/profile/presentation/views/widgets/analytics_row.dart';

class FreelancerEarningViewBody extends StatelessWidget {
  const FreelancerEarningViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
          Center(
            child: Text(
              "\$0",
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorsManager.primary,
                fontSize: 40.sp,
              ),
            ),
          ),
          Center(
            child: Text(
              "Available for withdrawal",
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
          ),

          SizedBox(height: 50.h),

          Text(
            "Analytics",
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Divider(thickness: 1, color: Colors.grey),
          SizedBox(height: 10.h),

          const AnalyticsRow(title: "Total Earnings", value: "\$0"),
          const AnalyticsRow(title: "Available for withdrawal", value: "0"),
          const AnalyticsRow(title: "Total orders", value: "0"),
          const AnalyticsRow(title: "Completed orders", value: "0"),

          const Spacer(),

          CustomButton(
            title: "Request Withdrawal",
            ontap: () {
              Navigator.pushNamed(
                context,
                RoutesManager.requestWithdrawalView,
              );
            },
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
 