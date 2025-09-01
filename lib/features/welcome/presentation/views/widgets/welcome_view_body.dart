import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/core/utils/routes_manager.dart';
import 'package:taskly/core/widgets/custom_button.dart';
import 'package:taskly/features/welcome/presentation/views/widgets/build_back_video.dart';
import 'package:taskly/features/welcome/presentation/views/widgets/gradient_overlay.dart';
import 'package:taskly/features/welcome/presentation/views/widgets/role_box.dart';
import 'package:taskly/features/welcome/presentation/views/widgets/role_selection_raw.dart';
import 'package:taskly/l10n/app_localizations.dart';
import 'package:video_player/video_player.dart';

import '../../../../../core/theme/app_theme.dart';

class WelcomeViewBody extends StatefulWidget {
  const WelcomeViewBody({super.key});

  @override
  State<WelcomeViewBody> createState() => _WelcomeViewBodyState();
}

class _WelcomeViewBodyState extends State<WelcomeViewBody> {
  late VideoPlayerController controller;
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.asset("assets/videos/welcome_video.mp4")
      ..initialize().then((_) {
        setState(() {});
        controller
          ..setLooping(true)
          ..setVolume(0.0)
          ..play();
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: double.infinity,
      height: size.height,
      child: Stack(
        children: [
          buildBackVideo(controller),
          const Positioned.fill(child: GradientOverlay()),
          Positioned(
            left: 0,
            right: 0,
            bottom: 50.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppLocalizations.of(context)!.appTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  AppLocalizations.of(context)!.welcomeMessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                RoleSelectionRow(
                  selectedIndex: selectedIndex,
                  onRoleSelected: (index) {
                    setState(() => selectedIndex = index);
                  },
                ),

                if (selectedIndex != -1) ...[
                  SizedBox(height: 20.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomBotton(
                      title:
                          selectedIndex == 0
                              ? "Create Freelancer Account"
                              : "Create Client Account",
                      ontap: () {
                        if (selectedIndex == 0) {
                          Navigator.pushNamed(context, RoutesManager.register,arguments: "freelancer");
                        } else {
                          Navigator.pushNamed(context, RoutesManager.register,arguments: "client");
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        GestureDetector(
                          onTap: () {
                            if (selectedIndex == 0) {
                              Navigator.pushNamed(context, RoutesManager.login,arguments: "freelancer");
                            } else {
                              Navigator.pushNamed(context, RoutesManager.login,arguments: "client");
                            }
                          },
                          child: Text(
                            'Log in',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
