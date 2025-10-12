import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/cache/shared_preferences.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/view_model/get_order_view_model.dart/get_order_view_model.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/order_status_card_list_view.dart';

import '../../../../../../../../config/l10n/app_localizations.dart';
import '../../../../../../../../core/components/dismissible_error_card.dart';
import '../view_model/delete_order_view_model/delete_order_states.dart';
import '../view_model/delete_order_view_model/delete_order_view_model.dart';

class MyJobsTabView extends StatelessWidget {
  MyJobsTabView({super.key});
  final String userId = SharedPrefHelper.getString("id")!;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetOrderViewModel>(
          create: (_) => getIt<GetOrderViewModel>()..loadAndSubscribeOrders(userId, "client"),
        ),
        BlocProvider<DeleteOrderViewModel>(
          create: (_) => getIt<DeleteOrderViewModel>(),
        ),
      ],
      child: BlocListener<DeleteOrderViewModel, DeleteOrderStates>(
        listener: (context, state) {
          if (state is DeleteOrderSuccessState) {
            context.read<GetOrderViewModel>().loadAndSubscribeOrders(userId, "client");
          }
          if (state is DeleteOrderErrorState) {
            showTemporaryMessage(context, "Failed to delete order", MessageType.error);
          }
        },
        child: DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              shape: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 2),
              ),
              title: Text(
                local.manageOrders,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp,
                ),
              ),
              bottom: TabBar(
                labelColor: ColorsManager.primary,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                unselectedLabelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
                indicatorColor: ColorsManager.primary,
                indicatorWeight: 4,
                tabs:   [
                  Tab(text: local.pending),
                  Tab(text: local.inProgress),
                  Tab(text: local.completed),
                  Tab(text: local.cancelled),
                ],
              ),
            ),
             body:   TabBarView(
              children: [
                OrderStatusCardListView(
                  animationPath: "assets/lotties/Loading.json",
                  message: local.no_pending_orders_yet,
                  filter: OrderStatusFilter.pending,
                ),
                OrderStatusCardListView(
                  animationPath: "assets/lotties/Progress.json",
                  message: local.no_orders_in_progress,
                  filter: OrderStatusFilter.inProgress,
                ),
                OrderStatusCardListView(
                  animationPath: "assets/lotties/Success.json",
                  message: local.no_completed_orders,
                  filter: OrderStatusFilter.completed,
                ),
                OrderStatusCardListView(
                  animationPath: "assets/lotties/cancelled.json",
                  message: local.no_cancelled_orders,
                  filter: OrderStatusFilter.cancelled,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

