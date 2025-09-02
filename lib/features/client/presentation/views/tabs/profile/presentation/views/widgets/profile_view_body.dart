import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/client/presentation/views/tabs/profile/presentation/views/widgets/account_item_row.dart';
import 'package:taskly/features/client/presentation/views/tabs/profile/presentation/views/widgets/user_info_section.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const UserInfoSection(),

            const SizedBox(height: 40),

            Text(
              "Support",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorsManager.primary,
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 10),
            AccountItemRow(
              image: Assets.assetsImagesChat6431892,
              text: "Technical Support",
              
            ),

            const SizedBox(height: 30),

            Text(
              "Account",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorsManager.primary,
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 10),
            AccountItemRow(
              image: Assets.assetsImagesChat6431892,
              text: "Language",
            ),
            const SizedBox(height: 10),
            AccountItemRow(
              image: Assets.assetsImagesChat6431892,
              text: "Theme",
            ),

            const SizedBox(height: 30),

            Text(
              "Settings",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorsManager.primary,
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 10),
            AccountItemRow(
              image: Assets.assetsImagesChat6431892,
              text: "Privacy Policy",
            ),
            const SizedBox(height: 10),
            AccountItemRow(
              image: Assets.assetsImagesChat6431892,
              text: "Terms & Conditions",
            ),

            SizedBox(height: 50.h),

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
