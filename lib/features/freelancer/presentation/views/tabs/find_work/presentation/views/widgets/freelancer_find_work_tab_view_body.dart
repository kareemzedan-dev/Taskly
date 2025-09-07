import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/widgets/custom_tab_bar.dart';
import 'package:taskly/features/client/presentation/cubit/client_info_view_model/client_info_view_model.dart';
import 'package:taskly/features/client/presentation/cubit/client_info_view_model/client_info_view_model_states.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/user_info_home_header.dart';
import 'package:taskly/features/freelancer/presentation/cubit/freelancer_info_view_model/freelancer_info_view_model.dart';
import 'package:taskly/features/freelancer/presentation/cubit/freelancer_info_view_model/freelancer_info_view_model_states.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/freelancer_work_card.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/search_bar_with_favorite.dart';

class FreelancerHomeTabViewBody extends StatefulWidget {
  FreelancerHomeTabViewBody({super.key});

  @override
  State<FreelancerHomeTabViewBody> createState() =>
      _FreelancerHomeTabViewBodyState();
}

late final FreelancerInfoViewModel _freelancerInfoViewModel;

class _FreelancerHomeTabViewBodyState extends State<FreelancerHomeTabViewBody> {
  final List<String> searchHintTexts = ["Search for jobs..."];
  @override
  void initState() {
    super.initState();
    _freelancerInfoViewModel = getIt<FreelancerInfoViewModel>();
    _freelancerInfoViewModel.loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BlocProvider(
              create: (context) => _freelancerInfoViewModel,
              child: BlocBuilder<FreelancerInfoViewModel, FreelancerInfoViewModelStates>(
                builder: (context, state) {
                  if (state is FreelancerInfoViewModelLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is FreelancerInfoViewModelSuccess) {
                    return UserInfoHomeHeader(
                      fullName: state.userInfoEntity.fullName,
                    );
                  } else if (state is FreelancerInfoViewModelError) {
                    return Text(state.errorMessage);
                  }
                  return Container();
                },
              ),
            ),
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
