import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/components/confirmation_dialog.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/view_model/delete_order_view_model/delete_order_view_model.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/state_bage.dart';

import '../../../../../../../../../config/l10n/app_localizations.dart';


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
    final local = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            StatusBadge(
              text: _getLocalizedStatus(local, orderStatus),
              color: ColorsManager.primary,
              icon: Icons.pending_actions_outlined,
            ),

            SizedBox(width: 5.w),
            if(orderStatus != "Paid" && orderStatus != "InProgress" &&
                orderStatus != "Waiting")
              GestureDetector(
                onTap: () {
                  showConfirmationDialog(
                    context: context,
                    title: local.confirm_delete,
                    message: local.delete_confirmation_message,
                    onConfirm: () {
                      context.read<DeleteOrderViewModel>().deleteOrder(orderId);
                    },
                  );
                },
                child:   StatusBadge(
                  text: local.delete,
                  color: Colors.red,
                  icon: Icons.delete,
                ),
              ),
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

      ],
    );
  }
}

String _getLocalizedStatus(AppLocalizations local, String status) {
  switch (status.toLowerCase()) {
    case "pending":
      return local.pending;
    case "inprogress":
      return local.inProgress;
    case "completed":
      return local.completed;
    case "cancelled":
      return local.cancelled;
    case "paid":
      return local.paid;
    case "waiting":
      return local.waiting;
    default:
      return status;
  }
}
