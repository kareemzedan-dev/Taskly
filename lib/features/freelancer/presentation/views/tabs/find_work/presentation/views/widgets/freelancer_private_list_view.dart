import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/cubit/get_order_view_model.dart/get_order_view_model_states.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/freelancer_work_card.dart';

class FreelancerPrivateOrdersList extends StatelessWidget {
  final GetOrderViewModelStates state;

  const FreelancerPrivateOrdersList({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is GetOrderViewModelStatesLoading) {
      return Expanded(
        child: Center(
          child: LoadingAnimationWidget.inkDrop(
            size: 50,
            color: ColorsManager.primary,
          ),
        ),
      );
    } else if (state is GetOrderViewModelStatesSuccess) {
      final orders = (state as GetOrderViewModelStatesSuccess).orderEntity;

      if (orders.isEmpty) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: const Center(
                child: Text(
                  'No private orders',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        );
      }

      return ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
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
    } else if (state is GetOrderViewModelStatesError) {
      return Center(
        child: Text((state as GetOrderViewModelStatesError).message),
      );
    }
    return Container();
  }
}
