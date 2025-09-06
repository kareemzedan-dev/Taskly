import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/widgets/custom_tab_bar.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/client_home_header.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/freelancer_work_card.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/search_bar_with_favorite.dart';

class FreelancerHomeTabViewBody extends StatelessWidget {
  FreelancerHomeTabViewBody({super.key});
  final List<String> searchHintTexts = ["Search for jobs..."];

  @override
  Widget build(BuildContext context) {
return DefaultTabController(
  length: 2,
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        UserInfoHomeHeader(fullName: "Kareem Zedan"),
        SizedBox(height: 20.h),
        SearchBarWithFavorite(hintTexts: searchHintTexts),
        SizedBox(height: 30.h),
        CustomTabBar(tabs: ["Public Requests", "Private Requests"]),
        SizedBox(height: 6.h),
        Divider(color: Colors.grey.shade300, thickness: 1.w),
        Expanded(
          child: TabBarView(
            children: [
              SingleChildScrollView(child: FreelancerWorkCard()),
              SingleChildScrollView(child: FreelancerWorkCard()),
            ],
          ),
        ),
      ],
    ),
  ),
);
  }
}