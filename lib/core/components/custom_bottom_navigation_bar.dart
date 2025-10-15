import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import '../../config/l10n/app_localizations.dart';
import 'package:taskly/features/messages/presentation/manager/unread_messages_badge_view_model/unread_badge_states.dart';
import 'package:taskly/features/messages/presentation/manager/unread_messages_badge_view_model/unread_messages_badge_view_model.dart';
import 'package:taskly/core/di/di.dart';

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
    final local = AppLocalizations.of(context)!;
    final unreadVM = getIt<UnreadMessagesBadgeViewModel>();

    return BlocBuilder<UnreadMessagesBadgeViewModel, UnreadMessagesBadgeState>(
      bloc: unreadVM,
      builder: (context, state) {
        int totalUnread = 0;
        if (state is UnreadMessagesBadgeUpdated) {
          totalUnread = state.unreadCounts.values.fold(0, (a, b) => a + b);
        }

        return BottomNavigationBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
          unselectedItemColor: Theme.of(context).textTheme.bodyLarge?.color,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                firstTabicon ?? Assets.assetsImagesHome4561540,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                height: 24.h,
                width: 24.w,
              ),
              activeIcon: Image.asset(
                firstTabicon ?? Assets.assetsImagesHome4561540,
                color: ColorsManager.primary,
                height: 24.h,
                width: 24.w,
              ),
              label: firstTabName ?? local.home,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                Assets.assetsImagesJobBoard18989826,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                height: 24.h,
                width: 24.w,
              ),
              activeIcon: Image.asset(
                Assets.assetsImagesJobBoard18989826,
                color: ColorsManager.primary,
                height: 24.h,
                width: 24.w,
              ),
              label: local.my_jobs,
            ),
            // 🟢 هنا نضيف البادج فوق أيقونة الشات
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    Assets.assetsImagesChat6431892,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    height: 24.h,
                    width: 24.w,
                  ),
                  if (totalUnread > 0)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: ColorsManager.primary,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Center(
                          child: Text(
                            totalUnread > 9 ? "9+" : "$totalUnread",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              activeIcon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    Assets.assetsImagesChat6431892,
                    color: ColorsManager.primary,
                    height: 24.h,
                    width: 24.w,
                  ),
                  if (totalUnread > 0)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: ColorsManager.primary,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Center(
                          child: Text(
                            totalUnread > 9 ? "9+" : "$totalUnread",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              label: local.messages,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                Assets.assetsImagesUser12366536,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                height: 24.h,
                width: 24.w,
              ),
              activeIcon: Image.asset(
                Assets.assetsImagesUser12366536,
                color: ColorsManager.primary,
                height: 24.h,
                width: 24.w,
              ),
              label: local.profile,
            ),
          ],
        );
      },
    );
  }
}
