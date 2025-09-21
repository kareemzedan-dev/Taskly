import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/cache/shared_preferences.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/components/custom_tab_bar.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/user_info_header_shimmer.dart' as shimmer;
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/user_info_home_header.dart' as header;

import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/cubit/freelancer_pending_order_view_model/freelancer_pending_order_view_model.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/cubit/freelancer_pending_order_view_model/freelancer_pending_order_view_model_states.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/freelancer_public_orders_list.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/freelancer_private_list_view.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/search_bar_with_favorite.dart';
import 'package:taskly/features/profile/presentation/manager/profile_view_model/profile_view_model_states.dart';

import '../../../../../../../../profile/presentation/manager/profile_view_model/profile_view_model.dart';
import '../../cubit/freelancer_private_orders_view_model/freelancer_private_orders_view_model.dart';
import '../../cubit/freelancer_private_orders_view_model/freelancer_private_orders_view_model_states.dart';

class FreelancerHomeTabViewBody extends StatefulWidget {
  const FreelancerHomeTabViewBody({super.key});

  @override
  State<FreelancerHomeTabViewBody> createState() =>
      _FreelancerHomeTabViewBodyState();
}

class _FreelancerHomeTabViewBodyState extends State<FreelancerHomeTabViewBody> {
  late final ProfileViewModel _freelancerInfoViewModel;
  late final FreelancerPendingOrdersViewModel _pendingOrdersViewModel;
  late final FreelancerPrivateOrdersViewModel _privateOrderViewModel;

  final List<String> searchHintTexts = ["Search for jobs..."];
  String userId = SharedPrefHelper.getString("id")!;

  @override
  void initState() {
    super.initState();
    _freelancerInfoViewModel = getIt<ProfileViewModel>()..getUserInfo(userId, "freelancer");


    _pendingOrdersViewModel = getIt<FreelancerPendingOrdersViewModel>();
    _pendingOrdersViewModel.fetchPendingFreelancerOrders();

    _privateOrderViewModel = getIt<FreelancerPrivateOrdersViewModel>();
    _privateOrderViewModel.fetchPrivateOrders(userId );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _freelancerInfoViewModel),
        BlocProvider.value(value: _pendingOrdersViewModel),
        BlocProvider.value(value: _privateOrderViewModel),
      ],
      child: DefaultTabController(
        length: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              BlocBuilder<
                ProfileViewModel,
                  ProfileViewModelStates
              >(
                builder: (context, state) {
                  if (state is ProfileViewModelStatesLoading) {
                    return   shimmer.UserInfoHomeHeaderShimmer();
                  } else if (state is ProfileViewModelStatesSuccess) {
                    return header. UserInfoHomeHeader(
                      fullName: state.userInfoEntity.fullName,
                    );
                  } else if (state is ProfileViewModelStatesError) {


                    return   shimmer.UserInfoHomeHeaderShimmer();
                  }
                  return const SizedBox.shrink();
                },
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
                    BlocBuilder<
                      FreelancerPendingOrdersViewModel,
                      FreelancerPendingOrdersState
                    >(
                      builder: (context, state) {
                        return RefreshIndicator(
                          onRefresh: () async {
                            await context
                                .read<FreelancerPendingOrdersViewModel>()
                                .fetchPendingFreelancerOrders();
                          },
                          child: FreelancerPublicOrdersList(state: state),
                        );
                      },
                    ),
                    BlocBuilder<FreelancerPrivateOrdersViewModel, FreelancerPrivateOrdersViewModelStates>(
                      builder: (context, state) {
                        return RefreshIndicator(
                          onRefresh: () async {
                            await context
                                .read<FreelancerPrivateOrdersViewModel>()
                                .fetchPrivateOrders(userId);
                          },
                          child: FreelancerPrivateOrdersList(state: state),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
