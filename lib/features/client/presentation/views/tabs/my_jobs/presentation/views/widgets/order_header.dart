import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/components/confirmation_dialog.dart';
import 'package:taskly/core/components/dismissible_error_card.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/view_model/delete_order_view_model/delete_order_view_model.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/state_bage.dart';

import '../../view_model/delete_order_view_model/delete_order_states.dart';

class OrderHeader extends StatelessWidget {
  final String orderName;
  final String orderId;
  final String orderStatus;

  const OrderHeader({
    super.key,
    required this.orderName,
    required this.orderId,
    required this.orderStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        StatusBadge(
          text: orderStatus,
          color: ColorsManager.primary,
          icon: Icons.pending_actions_outlined,
        ),
        SizedBox(width: 5.w),
        BlocProvider(create: (context) => getIt<DeleteOrderViewModel>(),
          child: BlocBuilder<DeleteOrderViewModel, DeleteOrderStates>(
            builder: (context, state) {
              if(state is DeleteOrderLoadingState){
                return const CircularProgressIndicator();
              }
              if(state is DeleteOrderSuccessState){
                  showConfirmationDialog(context: context,
                      title: "Confirm Delete", message: "Are you sure you want to delete this order?", onConfirm: () {
                        getIt<DeleteOrderViewModel>().deleteOrder(orderId);
                      },);
              }
              if(state is DeleteOrderErrorState){
                showTemporaryMessage( context ,  "Failed to delete order", MessageType.error);
              }
             return GestureDetector(
                onTap: () {
                  getIt<DeleteOrderViewModel>()..deleteOrder(orderId);
                },

                child: StatusBadge(
                  text: "Delete",
                  color: Colors.red,
                  icon: Icons.delete,
                ),
              );

            },))
          ],
        ),
        Text(
          orderName,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          softWrap: true,
        ),
        SizedBox(height: 3.h),
        Text(
          "#$orderId ",
          softWrap: true,
          style: Theme
              .of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
