import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/cubit/freelancer_pending_order_view_model/freelancer_pending_order_view_model_states.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/freelancer_work_card.dart';

import 'freelancer_work_card_shimmer.dart';

class FreelancerPublicOrdersList extends StatelessWidget {
  final FreelancerPendingOrdersState state;

  const FreelancerPublicOrdersList({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is FreelancerPendingOrdersLoading) {
      return FreelancerWorkCardShimmer();
    } else if (state is FreelancerPendingOrdersSuccess) {
      final orders =
          (state as FreelancerPendingOrdersSuccess).pendingOrdersList;

      if (orders.isEmpty) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Center(
                child: Column(
                  children: [
                    Image.asset(Assets.noOrderImage,width: 240.w,height: 240.h,),

                    SizedBox(height: 10.h),
                    Text(
                      'No Pubilc orders',
                      style: TextStyle(fontSize: 18.sp),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }

      return ListView.separated(
        separatorBuilder:
            (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(color: Colors.grey.shade300, thickness: 1.w),
            ),
        itemCount: orders.length,
        itemBuilder:
            (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: FreelancerWorkCard(order: orders[index]),
            ),
      );
    } else if (state is FreelancerPendingOrdersError) {
      return FreelancerWorkCardShimmer();
    }
    return Container();
  }
}
