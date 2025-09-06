import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/empty_state_animation.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/order_states_card.dart';

class MyJobsTabView extends StatelessWidget {
  const MyJobsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          shape: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300,
              width: 2,
            ),
          ),
          title: Text(
            'Manage Orders',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp,
                ),
          ),
          bottom: TabBar(
            labelColor: ColorsManager.primary,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            indicatorColor: ColorsManager.primary,
            indicatorWeight: 4,
            tabs: const [
              Tab(text: "Pending"),
              Tab(text: "In Progress"),
              Tab(text: "Completed"),
              Tab(text: "Cancelled"),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: const TabBarView(
          children: [
            // EmptyStateAnimation(
            //   animationPath: "assets/lotties/Loading.json",
            //   message: "No pending orders",
            // ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  OrderStatesCard(),
                  
                ],
              ),
            ),
            EmptyStateAnimation(
              animationPath: "assets/lotties/Progress.json",
              message: "No orders in progress",
            ),
            EmptyStateAnimation(
              animationPath: "assets/lotties/Success.json",
              message: "No completed orders",
            ),
            EmptyStateAnimation(
              animationPath: "assets/lotties/cancelled.json",
              message: "No cancelled orders",
            ),
          ],
        ),
      ),
    );
  }
}
