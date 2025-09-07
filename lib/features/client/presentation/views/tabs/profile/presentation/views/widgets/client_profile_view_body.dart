import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/features/client/presentation/cubit/client_info_view_model/client_info_view_model.dart';
import 'package:taskly/features/client/presentation/cubit/client_info_view_model/client_info_view_model_states.dart';
import 'package:taskly/features/client/presentation/views/tabs/profile/presentation/views/widgets/account_item_row.dart';
import 'package:taskly/features/client/presentation/views/tabs/profile/presentation/views/widgets/user_info_section.dart';
import 'package:taskly/features/shared/presentation/views/widgets/profile_section.dart';

class ClientProfileViewBody extends StatefulWidget {
  const ClientProfileViewBody({super.key});

  @override
  State<ClientProfileViewBody> createState() => _ClientProfileViewBodyState();
}

class _ClientProfileViewBodyState extends State<ClientProfileViewBody> {
  late final ClientInfoViewModel _userInfoViewModel;

  @override
  void initState() {
    super.initState();
    _userInfoViewModel = getIt<ClientInfoViewModel>();
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
              child: BlocBuilder<ClientInfoViewModel, ClientInfoViewModelStates>(
                builder: (context, state) {
                  if (state is ClientInfoViewModelLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is ClientInfoViewModelSuccess) {
                    return UserInfoSection(
                      email: state.userInfoEntity.email,
                      name: state.userInfoEntity.fullName!,
                    
                    );
                  } else if (state is ClientInfoViewModelError) {
                    return Text(state.errorMessage);
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
                ),
              ],
            ),

            ProfileSection(
              title: "Account",
              children: [
                AccountItemRow(
                  image: Assets.assetsImagesInternet2889312,
                  text: "Language",
                ),
                AccountItemRow(
                  image: Assets.assetsImagesBrushes3450037,
                  text: "Theme",
                ),
              ],
            ),

            ProfileSection(
              title: "Settings",
              children: [
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
