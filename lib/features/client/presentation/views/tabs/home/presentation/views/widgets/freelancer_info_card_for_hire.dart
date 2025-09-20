import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import '../../../../../../../../profile/domain/entities/user_info_entity/user_info_entity.dart';

class FreelancerInfoCardForHire extends StatelessWidget {
  final UserInfoEntity freelancer;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onReviewsTap; // جديد: وظيفة الضغط على أيقونة الريفيوز

  const FreelancerInfoCardForHire({
    super.key,
    required this.freelancer,
    required this.isSelected,
    required this.onTap,
    required this.onReviewsTap, // جديد
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? ColorsManager.primary : Colors.grey.shade300,
            width: 3.w,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              radius: 16.r,
              backgroundImage: AssetImage(
                Assets.assetsImagesPortraitHappySmileyMan,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    freelancer.fullName ?? "name is not available",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                    maxLines: 1,
                  ),
                  Text(
                    freelancer.bio ?? "Freelancer",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Rating
            Row(
              children: [
                Text(
                  freelancer.rating?.toStringAsFixed(1) ?? "0.0",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                const Icon(Icons.star, color: Colors.amber, size: 16),
              ],
            ),
            const SizedBox(width: 8),
            // Icon for Reviews
            GestureDetector(
              onTap: onReviewsTap,
              child: Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: ColorsManager.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.reviews,
                  color: ColorsManager.primary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
