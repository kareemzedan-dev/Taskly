import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:taskly/config/routes/routes_manager.dart';
import 'package:taskly/core/components/custom_button.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/view_model/update_offer_status_view_model/update_offer_status_states.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/view_model/update_offer_status_view_model/update_offer_status_view_model.dart';
import 'package:taskly/features/profile/presentation/widgets/user_info_section.dart';
import 'package:taskly/features/client/presentation/views/tabs/profile/presentation/views/widgets/user_info_section_shimmer.dart';
import 'package:taskly/features/freelancer/domain/entities/offer_entity/offer_entity.dart';
import 'package:taskly/features/freelancer/presentation/cubit/withdraw_offer_view_model/withdraw_offer_states.dart';
import 'package:taskly/features/freelancer/presentation/cubit/withdraw_offer_view_model/withdraw_offer_view_model.dart';
import 'package:taskly/features/profile/domain/entities/user_info_entity/user_info_entity.dart';

import '../../../../../../../../../core/di/di.dart';
import '../../../../../../../../../core/helper/convert_to_days.dart';
import '../../../../../../../../../core/utils/colors_manger.dart';
import '../../../../../../../../messages/presentation/widgets/admin_message_card.dart';
import '../../../../../../../../profile/presentation/manager/profile_view_model/profile_view_model.dart';
import '../../../../../../../../profile/presentation/manager/profile_view_model/profile_view_model_states.dart';
import '../../../../find_work/presentation/views/widgets/action_row.dart';
import '../../../../find_work/presentation/views/widgets/delivery_info.dart';
import '../../../../find_work/presentation/views/widgets/freelancer_work_card.dart';

class TrackingOfferCard extends StatelessWidget {
  TrackingOfferCard({
    super.key,
    required this.offerEntity,
    this.isPending = false,
    this.isAccepted = false,
    this.isRejected = false,
    this.isCompleted = false,
  });

  OfferEntity offerEntity;
  bool isPending;
  bool isAccepted;
  bool isRejected;
  bool isCompleted;

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
              if (isAccepted)
                AdminMessageCard(
                    message:
                        "Please wait until the payment is confirmed. Once confirmed, you can contact the client and start the work."),
              SizedBox(height: 5.h),
              BlocBuilder<ProfileViewModel, ProfileViewModelStates>(
                bloc: getIt<ProfileViewModel>()
                  ..getUserInfo(offerEntity.clientId, "client"),
                builder: (context, state) {
                  if (state is ProfileViewModelStatesLoading) {
                    return UserInfoSectionShimmer();
                  }
                  if (state is ProfileViewModelStatesError) {
                    return UserInfoSectionShimmer();
                  }
                  if (state is ProfileViewModelStatesSuccess) {
                    return UserInfoSection(
                      photoSizeSelected: true,
                      name: state.userInfoEntity.fullName,
                      email: state.userInfoEntity.email,
                      rating: state.userInfoEntity.rating!,
                      userInfo: state.userInfoEntity,
                    );
                  }
                  return const Center(child: Text("Loading"));
                },
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "Mind Map",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(4.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: ColorsManager.primary.withOpacity(0.1),
                      border: Border.all(
                          color: ColorsManager.primary.withOpacity(0.1),
                          width: 1.w),
                    ),
                    child: Text(
                      offerEntity.offerStatus,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: ColorsManager.primary),
                    ),
                  ),
                ],
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
              if (!isRejected && !isCompleted)
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
              if (isRejected)
                GestureDetector(
                  onTap: () {
                    context.read<UpdateOfferStatusViewModel>()
                      ..updateOfferStatus(offerEntity.id, "deleted");
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: Colors.white,
                      border: Border.all(color: Colors.red, width: 2.w),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            FontAwesomeIcons.close,
                            color: Colors.red,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Delete this offer',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              BlocBuilder<WithdrawOfferViewModel, WithdrawOfferStates>(
                builder: (context, state) {
                  return ActionsRow(
                    actions: [
                      if (!isRejected)
                        ActionItem(
                          title: "View details",
                          icon: Icons.remove_red_eye_outlined,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RoutesManager.offerDetailsView,
                              arguments: {
                                'orderId': offerEntity.orderId,
                              },
                            );
                          },
                        ),
                      if (isPending)
                        ActionItem(
                          title: state is WithdrawOfferStatesLoading
                              ? "Withdrawing..."
                              : "Withdraw offer",
                          icon: Icons.remove_circle_outline,
                          isOffer: true,
                          onTap: state is WithdrawOfferStatesLoading
                              ? null
                              : () {
                                  context
                                      .read<WithdrawOfferViewModel>()
                                      .withdrawOffer(
                                          offerEntity.id, offerEntity.orderId);
                                },
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
