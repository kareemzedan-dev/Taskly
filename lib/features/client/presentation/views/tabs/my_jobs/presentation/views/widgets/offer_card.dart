import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/helper/convert_to_days.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/view_model/update_offer_status_view_model/update_offer_status_view_model.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/offer_actions.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/price_duration_section.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/user_info_display.dart';
import 'package:taskly/features/profile/presentation/widgets/user_info_section.dart';
import 'package:taskly/features/freelancer/domain/entities/offer_entity/offer_entity.dart';
import 'package:taskly/features/profile/presentation/manager/profile_view_model/profile_view_model.dart';
import 'package:taskly/features/profile/presentation/manager/profile_view_model/profile_view_model_states.dart';

import '../../../../../../../../shared/domain/entities/order_entity/order_entity.dart';
import 'order_action_button.dart';

class OfferCard extends StatelessWidget {
  final OfferEntity offer;
  final OrderEntity order;
  final void Function()? onAcceptOffer;

  const OfferCard({
    super.key,
    required this.order,
    required this.offer,
    required this.onAcceptOffer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            border: Border.all(color: ColorsManager.primary, width: 1.w),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocProvider(
              create: (context) => getIt<ProfileViewModel>()
                ..getUserInfo(offer.freelancerId, "freelancer"),
              child: BlocBuilder<ProfileViewModel, ProfileViewModelStates>(
                builder: (context, state) {
                  String freelancerName = '';
                  String freelancerImage = '';
                  double rating = 0.0;
                  bool isVerified = false;
                  String? profileImage;
                  String? email;

                  if (state is ProfileViewModelStatesSuccess) {
                    freelancerName = state.userInfoEntity.fullName ?? '';
                    freelancerImage = state.userInfoEntity.profileImage ?? '';
                    rating = state.userInfoEntity.rating ?? 0.0;
                    isVerified = state.userInfoEntity.isVerified ?? false;
                    profileImage = state.userInfoEntity.profileImage ?? '';
                    email = state.userInfoEntity.email ?? '';

                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: state is ProfileViewModelStatesLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : state is ProfileViewModelStatesError
                                      ? Center(child: Text(state.message))
                                      : UserInfoDisplay(
                                name:  freelancerName,
                              email:  email!,
                              rating: rating,
                              profileImage: profileImage,
                              isFreelancer: isVerified,

                                        ),
                            ),
                            SizedBox(width: 8.w),
                            PriceDurationSection(
                              price: "\$${offer.offerAmount} SAR",
                              duration: offer.offerDeliveryTime.formatMinutes(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          offer.offerDescription ?? "No description provided",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: ColorsManager.black),
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Divider(
                        color: Colors.grey.shade300,
                        thickness: 1.w,
                        indent: 16.w,
                        endIndent: 16.w,
                      ),
                      SizedBox(height: 10.h),
                      OfferActions(
                        offerId: offer.id,
                        onAcceptOffer: onAcceptOffer!,
                        userName: freelancerName,
                        userImage: freelancerImage,
                        order: order,
                        currentUserId: offer.clientId,
                        receiverId: offer.freelancerId,
                      ),
                      SizedBox(height: 10.h),
                      OrderActionButton(
                        text: "Decline Offer",
                        icon: Icons.close,
                        color: Colors.red,
                        onTap: () {
                          context
                              .read<UpdateOfferStatusViewModel>()
                              .updateOfferStatus(
                                offer.id,
                                "Rejected",
                              );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
