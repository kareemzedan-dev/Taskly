import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/features/client/domain/entities/home/user_info_entity.dart';

class UserInfoHomeHeader extends StatelessWidget {
    UserInfoHomeHeader({super.key,required this.fullName});
  String? fullName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              "Hi ${fullName ??""},",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              "Welcome back",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
        CircleAvatar(
          backgroundColor: Colors.grey.shade300,
          radius: 30.r,
          backgroundImage: AssetImage(Assets.assetsImagesPortraitHappySmileyMan),
        ),
      ],
    );
  }
}
