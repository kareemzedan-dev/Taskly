import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/offer_actions.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/price_duration_section.dart';
import 'package:taskly/features/client/presentation/views/tabs/profile/presentation/views/widgets/user_info_section.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({super.key});

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
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const UserInfoSection(
                        name: "John Doe",
                        email: "johndoe@ex.com",
                        rating: 4.5,
                        emailShow: false,
                        photoSizeSelected: true,
                      ),
                      const PriceDurationSection(
                        price: "1200 \$",
                        duration: "1 day",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "I can create a detailed mind map for your project within 1 day. Please let me know if you are interested in this offer.",
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

                const OfferActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

 
  

  