import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/helper/convert_to_days.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/offer_actions.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/price_duration_section.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/user_info_display.dart';
import 'package:taskly/features/freelancer/domain/entities/offer_entity/offer_entity.dart';
import '../../../../../../../../shared/domain/entities/order_entity/order_entity.dart';
import '../../view_model/update_offer_status_view_model/update_offer_status_view_model.dart';
import 'expandable_text.dart';
import 'order_action_button.dart';

class OfferWithFreelancer {
  final OfferEntity offer;
  final String freelancerName;
  final String freelancerEmail;
  final String freelancerImage;
  final bool freelancerIsVerified;
  final double freelancerRating;

  OfferWithFreelancer({
    required this.offer,
    required this.freelancerName,
    required this.freelancerEmail,
    required this.freelancerImage,
    required this.freelancerIsVerified,
    required this.freelancerRating,
  });
}

class OfferCard extends StatelessWidget {
  final OfferWithFreelancer offer;
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
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row for user info + price & duration
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Info
                  Expanded(
                    child: UserInfoDisplay(
                      name: offer.freelancerName,
                      email: offer.freelancerEmail,
                      rating: offer.freelancerRating,
                      profileImage: offer.freelancerImage,
                      isFreelancer: offer.freelancerIsVerified,
                    ),
                  ),

                  // Price & Duration
                  PriceDurationSection(
                    price: "${offer.offer.offerAmount} \$",
                    duration: offer.offer.offerDeliveryTime.formatMinutes(),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Description
              ExpandableText(
                text: offer.offer.offerDescription ?? "No description provided",
              ),

              SizedBox(height: 12.h),
              Divider(color: Colors.grey.shade300, thickness: 1.w),

              SizedBox(height: 8.h),

              // Actions (Accept / Reject)
              OfferActions(
                offerId: offer.offer.id,
                onAcceptOffer: onAcceptOffer!,
                userName: offer.freelancerName,
                userImage: offer.freelancerImage,
                order: order,
                currentUserId: offer.offer.clientId,
                receiverId: offer.offer.freelancerId,
              ),
              SizedBox(height: 10.h),

              // Reject button
              OrderActionButton(
                text: "Decline Offer",
                icon: Icons.close,
                color: Colors.red,
                onTap: () {

          context.read<UpdateOfferStatusViewModel>().updateOfferStatus(offer.offer.id, "Rejected");


                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
