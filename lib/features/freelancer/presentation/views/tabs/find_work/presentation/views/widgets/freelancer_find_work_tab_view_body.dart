import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:taskly/config/routes/routes_manager.dart';
import 'package:taskly/core/cache/shared_preferences.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/components/custom_tab_bar.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/user_info_home_header.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/cubit/get_order_view_model.dart/get_order_view_model.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/cubit/get_order_view_model.dart/get_order_view_model_states.dart';
import 'package:taskly/features/freelancer/presentation/cubit/freelancer_info_view_model/freelancer_info_view_model.dart';
import 'package:taskly/features/freelancer/presentation/cubit/freelancer_info_view_model/freelancer_info_view_model_states.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/cubit/freelancer_pending_order_view_model/freelancer_pending_order_view_model.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/cubit/freelancer_pending_order_view_model/freelancer_pending_order_view_model_states.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/freelancer_public_orders_list.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/freelancer_private_list_view.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/freelancer_work_card.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/search_bar_with_favorite.dart';

class FreelancerHomeTabViewBody extends StatefulWidget {
  const FreelancerHomeTabViewBody({super.key});

  @override
  State<FreelancerHomeTabViewBody> createState() =>
      _FreelancerHomeTabViewBodyState();
}

class _FreelancerHomeTabViewBodyState extends State<FreelancerHomeTabViewBody> {
  late final FreelancerInfoViewModel _freelancerInfoViewModel;
  late final FreelancerPendingOrdersViewModel _pendingOrdersViewModel;
  late final GetOrderViewModel _privateOrderViewModel;

  final List<String> searchHintTexts = ["Search for jobs..."];
  String userId = SharedPrefHelper.getString("id")!;

  @override
  void initState() {
    super.initState();
    _freelancerInfoViewModel = getIt<FreelancerInfoViewModel>();
    _freelancerInfoViewModel.loadUserInfo();

    _pendingOrdersViewModel = getIt<FreelancerPendingOrdersViewModel>();
    _pendingOrdersViewModel.fetchPendingFreelancerOrders();

    _privateOrderViewModel = getIt<GetOrderViewModel>();
    _privateOrderViewModel.getUserOrdersByUserId(userId, "freelancer");
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
                FreelancerInfoViewModel,
                FreelancerInfoViewModelStates
              >(
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
                    BlocBuilder<GetOrderViewModel, GetOrderViewModelStates>(
                      builder: (context, state) {
                        return RefreshIndicator(
                          onRefresh: () async {
                            await context
                                .read<GetOrderViewModel>()
                                .getUserOrdersByUserId(userId, "freelancer");
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
