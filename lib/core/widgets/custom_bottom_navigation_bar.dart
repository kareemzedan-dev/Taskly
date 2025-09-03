import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/core/utils/colors_manger.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.firstTabName,
    this.firstTabicon,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final String? firstTabName;
  final String? firstTabicon;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.transparent,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Colors.transparent,
      ),
      selectedItemColor: ColorsManager.primary,
      unselectedItemColor: Colors.black.withOpacity(0.5),
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            firstTabicon ?? Assets.assetsImagesHome4561540,
            color: Colors.black.withOpacity(0.5),
            height: 24.h,
            width: 24.w,
          ),
          activeIcon: Image.asset(
            firstTabicon ?? Assets.assetsImagesHome4561540,
            color: ColorsManager.primary,
            height: 24.h,
            width: 24.w,
          ),
          label: firstTabName ?? 'Home',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            Assets.assetsImagesJobBoard18989826,
            color: Colors.black.withOpacity(0.5),
            height: 24.h,
            width: 24.w,
          ),
          activeIcon: Image.asset(
            Assets.assetsImagesJobBoard18989826,
            color: ColorsManager.primary,
            height: 24.h,
            width: 24.w,
          ),
          label: 'My Jobs',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            Assets.assetsImagesChat6431892,
            color: Colors.black.withOpacity(0.5),
            height: 24.h,
            width: 24.w,
          ),
          activeIcon: Image.asset(
            Assets.assetsImagesChat6431892,
            color: ColorsManager.primary,
            height: 24.h,
            width: 24.w,
          ),
          label: 'Messages',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            Assets.assetsImagesUser12366536,
            color: Colors.black.withOpacity(0.5),
            height: 24.h,
            width: 24.w,
          ),
          activeIcon: Image.asset(
            Assets.assetsImagesUser12366536,
            color: ColorsManager.primary,
            height: 24.h,
            width: 24.w,
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
