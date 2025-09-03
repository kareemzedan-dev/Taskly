import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/core/widgets/custom_search_text_field.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/client_home_header.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/service_category.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/service_category_grid_view.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/freelancer_work_card.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/search_bar_with_favorite.dart';

class FreelancerHomeTabViewBody extends StatelessWidget {
  FreelancerHomeTabViewBody({super.key});
  final List<String> searchHintTexts = ["Search for jobs..."];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              UserInfoHomeHeader(fullName: "Kareem Zedan"),
              SizedBox(height: 20.h),
           SearchBarWithFavorite(hintTexts: searchHintTexts,),
              SizedBox(height: 30.h),
              TabBar(
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
                  Tab(text: "Public Requests"),
                  Tab(text: "Private Requests"),
                ],
              ),
              SizedBox(height: 6.h),
              Divider(color: Colors.grey.shade300, thickness: 1.w),
              SizedBox(height: 16.h),
              FreelancerWorkCard(),
            ],
          ),
        ),
      ),
    );
  }
}
