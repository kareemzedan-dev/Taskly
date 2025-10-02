import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/features/reviews/presentation/widgets/user_avatar.dart';

class UserInfoHomeHeader extends StatelessWidget {
  const UserInfoHomeHeader({super.key, required this.fullName, required this.imageUrl});
  final String? fullName;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              "Hi ${fullName ?? ""},",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600,       fontSize: 16.sp,),
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
       UserAvatar( imagePath: imageUrl, radius: 24.r,)
      ],
    );
  }
}
