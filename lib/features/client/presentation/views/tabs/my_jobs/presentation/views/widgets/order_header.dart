
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/state_bage.dart';

class OrderHeader extends StatelessWidget {
  final String orderName;
  final String orderId;

  const OrderHeader({
    super.key,
    required this.orderName,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
 Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisAlignment: MainAxisAlignment.center ,
  children: [
    Expanded(
      child: Text(
        orderName,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        softWrap: true,  
      ),
    ),
    SizedBox(width: 8.w),
    StatusBadge(
      text: "Pending",
      color: ColorsManager.primary,
      icon: Icons.pending_actions_outlined,
    ),
    SizedBox(width: 5.w),
    StatusBadge(
      text: "Delete",
      color: Colors.red,
      icon: Icons.delete,
    ),
  ],
)
,
        SizedBox(height: 3.h),
        Text(
          "#$orderId ",
          softWrap: true,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.grey.shade600),

        ),

      ],
    );
  }
}
 