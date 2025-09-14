import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/config/routes/routes_manager.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/features/client/presentation/views/tabs/profile/presentation/views/widgets/account_item_row.dart';
import 'package:taskly/features/client/presentation/views/tabs/profile/presentation/views/widgets/user_info_section.dart';
import 'package:taskly/features/shared/presentation/views/widgets/language_bottom_sheet_content.dart';
import 'package:taskly/features/shared/presentation/views/widgets/profile_section.dart';
import 'package:taskly/features/shared/presentation/views/widgets/theme_bottom_sheet_content.dart';

class FreelancerProfileViewBody extends StatefulWidget {
  const FreelancerProfileViewBody({super.key});

  @override
  State<FreelancerProfileViewBody> createState() =>
      _FreelancerProfileViewBodyState();
}

class _FreelancerProfileViewBodyState extends State<FreelancerProfileViewBody> {
  String _currentLanguage = "English";

  String _currentTheme = "Light";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            UserInfoSection(
              email: "Kareem@gmail.com",
              name: "kareem",
              onTap: () {
                Navigator.pushNamed(context, RoutesManager.userAccountView);
              },
              isFreelancer: true,
            ),

            SizedBox(height: 40.h),
            ProfileSection(
              title: "Dashboard",
              children: [
                AccountItemRow(
                  image: Assets.assetsImagesWallet2527857,
                  text: "Earnings",
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RoutesManager.freelancerEarningView,
                    );
                  },
                ),
                SizedBox(height: 10.h),
                AccountItemRow(
                  image: Assets.assetsImagesWithdrawal8211181,
                  text: "Withdraw Balance",
                  onTap: () {
                          Navigator.pushNamed(
                context,
                RoutesManager.requestWithdrawalView,
              );
                  },
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
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RoutesManager.technicalSupportView,
                    );
                  },
                ),
              ],
            ),

            ProfileSection(
              title: "Account",
              children: [
                AccountItemRow(
                  image: Assets.assetsImagesInternet2889312,
                  text: "Language",
                  onTap: () async {
                    final selected = await showModalBottomSheet<String>(
                      context: context,
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      builder: (context) {
                        return LanguageBottomSheetContent(
                          initialLanguage: _currentLanguage,
                        );
                      },
                    );

                    if (selected != null) {
                      setState(() {
                        _currentLanguage = selected;
                      });
                    }
                  },
                ),
                AccountItemRow(
                  image: Assets.assetsImagesBrushes3450037,
                  text: "Theme",
                  onTap: () async {
                    final selectedTheme = await showModalBottomSheet<String>(
                      context: context,
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      builder: (context) {
                        return ThemeBottomSheetContent(
                          initialTheme: _currentTheme,
                        );
                      },
                    );

                    if (selectedTheme != null) {
                      setState(() {
                        _currentTheme = selectedTheme;
                      });
                    }
                  },
                ),
                SizedBox(height: 10.h),

                AccountItemRow(
                  image: Assets.assetsImagesCahngePassword,
                  text: "Change Password",
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RoutesManager.changePasswordView,
                    );
                  },
                ),
              ],
            ),
            ProfileSection(
              title: "Settings",
              children: [
                SizedBox(height: 10.h),
                AccountItemRow(
                  image: Assets.assetsImagesAccount3166234,
                  text: "Privacy Policy",
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RoutesManager.privacyPolicyView,
                    );
                  },
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
