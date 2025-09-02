import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/core/widgets/circle_icon_button.dart';
import 'package:taskly/features/client/presentation/views/tabs/profile/presentation/views/widgets/profile_view_body.dart';

class ProfileViewTab extends StatelessWidget {
  const ProfileViewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Profile',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(     
                   fontWeight: FontWeight.w700,
            fontSize: 20.sp,),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CircularIconButton(image: Assets.assetsImagesSettings),
          ),
        ],
      ),

      body: ProfileViewBody(),
    );
  }
}
