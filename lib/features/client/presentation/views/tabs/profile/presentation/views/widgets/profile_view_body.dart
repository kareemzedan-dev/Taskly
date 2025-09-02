import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/features/client/presentation/cubit/user_view_model/user_info_view_model.dart';
import 'package:taskly/features/client/presentation/cubit/user_view_model/user_info_view_model_states.dart';
import 'package:taskly/features/client/presentation/views/tabs/profile/presentation/views/widgets/account_item_row.dart';
import 'package:taskly/features/client/presentation/views/tabs/profile/presentation/views/widgets/user_info_section.dart';

class ProfileViewBody extends StatefulWidget {
  const ProfileViewBody({super.key});

  @override
  State<ProfileViewBody> createState() => _ProfileViewBodyState();
}

 
class _ProfileViewBodyState extends State<ProfileViewBody> {
  late final UserInfoViewModel _userInfoViewModel;

  @override
  void initState() {
    super.initState();
    _userInfoViewModel = getIt<UserInfoViewModel>();
    _userInfoViewModel.loadUserInfo();
  }

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
              create: (context) => _userInfoViewModel,
              child: BlocBuilder<UserInfoViewModel, UserInfoViewModelStates>(
                builder: (context, state) {
                  if (state is UserInfoViewModelLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is UserInfoViewModelSuccess) {
                    return UserInfoSection(
                      email: state.userInfoEntity.email,
                      name: state.userInfoEntity.fullName!,
                    );
                  } else if (state is UserInfoViewModelError) {
                    return Text(state.errorMessage);
                  }
                  return Container();
                },
              ),
            ),

            const SizedBox(height: 40),

            Text(
              "Support",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,

                fontSize: 18.sp,
              ),
            ),
            const SizedBox(height: 10),
            AccountItemRow(
              image: Assets.assetsImagesTechSupport5109502,
              text: "Technical Support",
            ),

            const SizedBox(height: 30),

            Text(
              "Account",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,

                fontSize: 18.sp,
              ),
            ),
            const SizedBox(height: 10),
            AccountItemRow(
              image: Assets.assetsImagesInternet2889312,
              text: "Language",
            ),
            const SizedBox(height: 10),
            AccountItemRow(
              image: Assets.assetsImagesBrushes3450037,
              text: "Theme",
            ),

            const SizedBox(height: 30),

            Text(
              "Settings",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,

                fontSize: 18.sp,
              ),
            ),
            const SizedBox(height: 10),
            AccountItemRow(
              image: Assets.assetsImagesAccount3166234,
              text: "Privacy Policy",
            ),
            const SizedBox(height: 10),
            AccountItemRow(
              image: Assets.assetsImagesDocument10103871,
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
