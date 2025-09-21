import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/config/routes/routes_manager.dart';
import 'package:taskly/core/cache/shared_preferences.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/core/utils/strings_manager.dart';
import 'package:taskly/features/client/presentation/views/tabs/profile/presentation/views/widgets/account_item_row.dart';
import 'package:taskly/features/client/presentation/views/tabs/profile/presentation/views/widgets/user_info_section.dart';
import 'package:taskly/features/client/presentation/views/tabs/profile/presentation/views/widgets/user_info_section_shimmer.dart';
import 'package:taskly/features/profile/presentation/manager/profile_view_model/profile_view_model.dart';
import 'package:taskly/features/profile/presentation/manager/profile_view_model/profile_view_model_states.dart';
import 'package:taskly/features/shared/presentation/views/widgets/language_bottom_sheet_content.dart';
import 'package:taskly/features/shared/presentation/views/widgets/profile_section.dart';
import 'package:taskly/features/shared/presentation/views/widgets/theme_bottom_sheet_content.dart';

class ClientProfileViewBody extends StatefulWidget {
  const ClientProfileViewBody({super.key});

  @override
  State<ClientProfileViewBody> createState() => _ClientProfileViewBodyState();
}

class _ClientProfileViewBodyState extends State<ClientProfileViewBody> {
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
            BlocProvider(
              create:
                  (context) =>
                      getIt<ProfileViewModel>()..getUserInfo(
                        SharedPrefHelper.getString(StringsManager.idKey)!,
                        "client",
                      ),
              child: BlocBuilder<ProfileViewModel, ProfileViewModelStates>(
                builder: (context, state) {
                  if (state is ProfileViewModelStatesLoading) {
                    return const UserInfoSectionShimmer();
                  } else if (state is ProfileViewModelStatesSuccess) {
                    return UserInfoSection(
                      userInfo: state.userInfoEntity,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RoutesManager.userAccountView,
                        );
                      },
                      email: state.userInfoEntity.email,
                      name: state.userInfoEntity.fullName!,
                    );
                  } else if (state is ProfileViewModelStatesError) {
                    return Text(state.message);
                  }
                  return Container();
                },
              ),
            ),

            SizedBox(height: 40.h),
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
