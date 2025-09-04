import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/app_text_styles.dart';
import 'package:taskly/core/utils/assets_manager.dart';

class UserInfoSection extends StatelessWidget {
  final String name, email;
  final double rating;
  final bool isFreelancer;

  const UserInfoSection({
    super.key,
    required this.name,
    required this.email,
    this.rating = 1.0,
    this.isFreelancer = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40.r,
          backgroundImage: AssetImage(
            Assets.assetsImagesPortraitHappySmileyMan,
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: AppTextStyles.bold20),
            Text(
              email,
              style: AppTextStyles.bold16.copyWith(color: Colors.grey),
            ),
            Row(
              children: [
                ...List.generate(5, (index) {
                  return Icon(
                    index < rating.round()
                        ? CupertinoIcons.star_fill
                        : CupertinoIcons.star,
                    color: Colors.amber,
                    size: 14.sp,
                  );
                }),
                SizedBox(width: 10.w),
                Text(
                  '($rating)',
                  style: AppTextStyles.bold16.copyWith(color: Colors.grey),
                ),
              ],
            ),
            if (isFreelancer)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.verified_user_outlined, color: Colors.green,size: 14.sp,),
                  SizedBox(width: 5.w),
                  Text(
                    isFreelancer ? 'Verified Freelancer' : '',
                    style: AppTextStyles.bold14.copyWith(color: Colors.grey),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
