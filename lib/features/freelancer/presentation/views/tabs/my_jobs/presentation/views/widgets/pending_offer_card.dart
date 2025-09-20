import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/config/routes/routes_manager.dart';
import 'package:taskly/features/client/presentation/views/tabs/profile/presentation/views/widgets/user_info_section.dart';
import 'package:taskly/features/freelancer/domain/entities/offer_entity/offer_entity.dart';
import 'package:taskly/features/profile/domain/entities/user_info_entity/user_info_entity.dart';

import '../../../../../../../../../core/di/di.dart';
import '../../../../../../../../../core/helper/convert_to_days.dart';
import '../../../../../../../../../core/utils/colors_manger.dart';
import '../../../../../../../../profile/presentation/manager/profile_view_model/profile_view_model.dart';
import '../../../../../../../../profile/presentation/manager/profile_view_model/profile_view_model_states.dart';
import '../../../../find_work/presentation/views/widgets/action_row.dart';
import '../../../../find_work/presentation/views/widgets/delivery_info.dart';
import '../../../../find_work/presentation/views/widgets/freelancer_work_card.dart';

class PendingOfferCard extends StatelessWidget {
  PendingOfferCard({super.key, required this.offerEntity});

  OfferEntity offerEntity;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 2.w),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<ProfileViewModel, ProfileViewModelStates>(
                bloc:
                    getIt<ProfileViewModel>()
                      ..getUserInfo(offerEntity.clientId, "client"),

                builder: (context, state) {
                  if (state is ProfileViewModelStatesLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: ColorsManager.primary,
                      ),
                    );
                  }
                  if (state is ProfileViewModelStatesError) {
                    return Center(child: Text(state.message));
                  }
                  if (state is ProfileViewModelStatesSuccess) {
                    return UserInfoSection(
                      photoSizeSelected: true,
                      name: state.userInfoEntity.fullName,
                      email: state.userInfoEntity.email,
                      rating: state.userInfoEntity.rating!,
                    );
                  }
                  return const Center(child: Text("Loading"));
                },
              ),
              SizedBox(height: 16.h),
              Text(
                "Mind Map",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.h),
              Text(
                "Proposal description:${offerEntity.offerDescription} ",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.h),
              DeliveryInfo(
                deliveryTime: offerEntity.offerDeliveryTime.formatMinutes(),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(Icons.attach_money_outlined, size: 15.sp),

                  Text(
                    "${offerEntity.offerAmount} SAR",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
                  ),
                ],
              ),

              SizedBox(height: 8.h),
              ActionsRow(
                actions: [
                  ActionItem(
                    title: "View details",
                    icon: Icons.remove_red_eye_outlined,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RoutesManager.offerDetailsView,
                        arguments: {
                          'orderId': offerEntity.orderId,
                        }
                      );
                    },
                  ),
                  ActionItem(
                    title: "Withdraw offer",

                    icon: Icons.remove_circle_outline,
                    isOffer: true,
                    onTap: () {},
                  ),
                ],
              ),

              //ActionsRow(order:),
            ],
          ),
        ),
      ),
    );
  }
}
