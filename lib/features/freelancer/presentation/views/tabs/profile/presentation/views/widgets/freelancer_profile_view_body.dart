import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/features/client/presentation/views/tabs/profile/presentation/views/widgets/account_item_row.dart';
import 'package:taskly/features/client/presentation/views/tabs/profile/presentation/views/widgets/user_info_section.dart';
import 'package:taskly/features/shared/presentation/views/widgets/profile_section.dart';

class FreelancerProfileViewBody extends StatelessWidget {
  const FreelancerProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const UserInfoSection(
              email: "Kareem@gmail.com",
              name: "kareem",
              isFreelancer: true,
            ),

            SizedBox(height: 40.h),
            ProfileSection(
              title: "Dashboard",
              children: [
                AccountItemRow(
                  image: Assets.assetsImagesWallet2527857,
                  text: "Earnings",
                ),
                SizedBox(height: 10.h),
                AccountItemRow(
                  image: Assets.assetsImagesWithdrawal8211181,
                  text: "Withdraw Balance",
                ),
                SizedBox(height: 10.h),
                AccountItemRow(
                  image: Assets.assetsImagesDocument10103871,
                  text: "My Orders",
                ),
              ],
            ),

            ProfileSection(
              title: "Work",
              children: [
                SizedBox(height: 10.h),
                AccountItemRow(
                  image: Assets.assetsImagesStar967444,
                  text: "Reviews & Ratings",
                ),
              ],
            ),

            ProfileSection(
              title: "Support",
              children: [
                AccountItemRow(
                  image: Assets.assetsImagesTechSupport5109502,
                  text: "Technical Support",
                ),
                SizedBox(height: 10.h),
                AccountItemRow(
                  image: Assets.assetsImagesFaq6736884,
                  text: "FAQs",
                ),
              ],
            ),

            ProfileSection(
              title: "Settings",
              children: [
                AccountItemRow(
                  image: Assets.assetsImagesInternet2889312,
                  text: "Language",
                ),
                SizedBox(height: 10.h),
                AccountItemRow(
                  image: Assets.assetsImagesBrushes3450037,
                  text: "Theme",
                ),
                SizedBox(height: 10.h),
                AccountItemRow(
                  image: Assets.assetsImagesAccount3166234,
                  text: "Privacy Policy",
                ),
                SizedBox(height: 10.h),
                AccountItemRow(
                  image: Assets.assetsImagesDocument10103871,
                  text: "Terms & Conditions",
                ),
              ],
            ),

            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    const SizedBox(width: 12),
                    Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
