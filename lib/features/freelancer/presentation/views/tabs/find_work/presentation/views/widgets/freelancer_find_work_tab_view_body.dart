import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:taskly/core/cache/shared_preferences.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/components/custom_tab_bar.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/user_info_header_shimmer.dart'
    as shimmer;
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/user_info_home_header.dart'
    as header;
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/view_model/freelancer_public_order_view_model/freelancer_public_order_states.dart';

import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/view_model/freelancer_public_order_view_model/freelancer_public_order_view_model.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/freelancer_public_orders_list.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/freelancer_private_list_view.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/search_bar_with_favorite.dart';
import 'package:taskly/features/profile/presentation/manager/profile_view_model/profile_view_model_states.dart';

import '../../../../../../../../profile/presentation/manager/profile_view_model/profile_view_model.dart';
import '../../../../../../../data/models/favorite_order_model/favorite_order_model.dart';
import '../../view_model/add_favorite_order_view_model/add_favorite_order_view_model.dart';
import '../../view_model/freelancer_private_orders_view_model/freelancer_private_orders_view_model.dart';
import '../../view_model/freelancer_private_orders_view_model/freelancer_private_orders_view_model_states.dart';
import '../../view_model/remove_favorite_order_view_model/remove_favorite_order_view_model.dart';

class FreelancerHomeTabViewBody extends StatefulWidget {
  const FreelancerHomeTabViewBody({super.key});

  @override
  State<FreelancerHomeTabViewBody> createState() =>
      _FreelancerHomeTabViewBodyState();
}

class _FreelancerHomeTabViewBodyState extends State<FreelancerHomeTabViewBody> {
  late final ProfileViewModel _freelancerInfoViewModel;
  late final FreelancerPublicOrdersViewModel _pendingOrdersViewModel;
  late final FreelancerPrivateOrdersViewModel _privateOrderViewModel;
  late final AddFavoriteOrderViewModel _addFavoriteOrderViewModel;
  late final RemoveFavoriteOrderViewModel _removeFavoriteOrderViewModel;

  final List<String> searchHintTexts = ["Search for jobs..."];
  String userId = SharedPrefHelper.getString("id")!;

  @override
  void initState() {
    super.initState();

    _freelancerInfoViewModel = getIt<ProfileViewModel>()..getUserInfo(userId, "freelancer");

    _pendingOrdersViewModel = getIt<FreelancerPublicOrdersViewModel>();
    _pendingOrdersViewModel.fetchAndSubscribePendingOrders();

    _privateOrderViewModel = getIt<FreelancerPrivateOrdersViewModel>();
    _privateOrderViewModel.fetchAndSubscribePrivateOrders(userId);

    _addFavoriteOrderViewModel = getIt<AddFavoriteOrderViewModel>();

    final savedJsonList = SharedPrefHelper.getStringList('favoriteOrders') ?? [];
    final savedFavorites = savedJsonList.map((jsonStr) {
      return FavoriteOrderModel.fromJson(jsonDecode(jsonStr));
    }).toList();
    _addFavoriteOrderViewModel.loadFavorites(savedFavorites);

    _removeFavoriteOrderViewModel = getIt<RemoveFavoriteOrderViewModel>();
  }




  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _freelancerInfoViewModel),
        BlocProvider.value(value: _pendingOrdersViewModel),
        BlocProvider.value(value: _privateOrderViewModel),
        BlocProvider.value(value: _addFavoriteOrderViewModel),
        BlocProvider.value(value: _removeFavoriteOrderViewModel),

      ],
      child: DefaultTabController(
        length: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [

                header.UserInfoHomeHeader(

          ),
              SizedBox(height: 20.h),
              SearchBarWithFavorite(hintTexts: searchHintTexts),
              SizedBox(height: 30.h),
              CustomTabBar(tabs: ["Public Requests", "Private Requests"]),
              SizedBox(height: 6.h),
              Divider(color: Colors.grey.shade300, thickness: 1.w),

              BlocBuilder<ProfileViewModel, ProfileViewModelStates>(
                builder: (context, state) {
                  if (state is ProfileViewModelStatesSuccess &&
                      state.userInfoEntity.isVerified!) {
                    return Expanded(
                      child: TabBarView(
                        children: [
                          BlocBuilder<
                              FreelancerPublicOrdersViewModel,
                              FreelancerPublicOrdersState
                          >(
                            builder: (context, pendingState) {
                              return RefreshIndicator(
                                onRefresh: () async {
                                  await context
                                      .read<FreelancerPublicOrdersViewModel>()
                                      .fetchAndSubscribePendingOrders();
                                },
                                child: FreelancerPublicOrdersList(
                                  state: pendingState,
                                  addFavViewModel: _addFavoriteOrderViewModel,

                                ),
                              );
                            },
                          ),
                          BlocBuilder<
                            FreelancerPrivateOrdersViewModel,
                            FreelancerPrivateOrdersViewModelStates
                          >(
                            builder: (context, privateState) {
                              return RefreshIndicator(
                                onRefresh: () async {
                                  await context
                                      .read<FreelancerPrivateOrdersViewModel>()
                                      .fetchAndSubscribePrivateOrders(userId);
                                },
                                child: FreelancerPrivateOrdersList(
                                  state: privateState,
                                  addFavViewModel: _addFavoriteOrderViewModel,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: ColorsManager.primary.withOpacity(0.1),
                          border: Border.all(
                            color: ColorsManager.primary.withOpacity(0.3),
                            width: 1.w,
                          ),
                        ),

                        child: Lottie.asset("assets/lotties/waiting.json"),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Your account is under verification.\nPlease wait until your request is approved.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
