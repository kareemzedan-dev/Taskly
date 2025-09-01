import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/routes_manager.dart';
import 'package:taskly/core/widgets/custom_button.dart';
import 'package:taskly/features/welcome/presentation/cubit/welcome_states.dart';
import 'package:taskly/features/welcome/presentation/cubit/welcome_view_model.dart';
import 'package:taskly/features/welcome/presentation/views/widgets/build_back_video.dart';
import 'package:taskly/features/welcome/presentation/views/widgets/gradient_overlay.dart';
import 'package:taskly/features/welcome/presentation/views/widgets/role_selection_raw.dart';
import 'package:taskly/l10n/app_localizations.dart';

class WelcomeViewBody extends StatelessWidget {
  const WelcomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (_) => WelcomeViewModel(),
      child: BlocBuilder<WelcomeViewModel, WelcomeState>(
        builder: (context, state) {
          final cubit = context.read<WelcomeViewModel>();

          return SizedBox(
            width: double.infinity,
            height: size.height,
            child: Stack(
              children: [
                if (state.status == WelcomeStatus.videoReady)
                  BackVideo(controller: cubit.controller),
                const Positioned.fill(child: GradientOverlay()),

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 50.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.appTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 40.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        AppLocalizations.of(context)!.welcomeMessage,
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.sp,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      RoleSelectionRow(
                        selectedRole: state.selectedRole,
                        onRoleSelected: cubit.selectRole,
                      ),
                      if (state.selectedRole != null) ...[
                        SizedBox(height: 20.h),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: CustomBotton(
                            title:
                                state.selectedRole == UserRole.freelancer
                                    ? AppLocalizations.of(
                                      context,
                                    )!.createFreelancerAccount
                                    : AppLocalizations.of(
                                      context,
                                    )!.createClientAccount,
                            ontap: () {
                              Navigator.pushNamed(
                                context,
                                RoutesManager.register,
                                arguments:
                                    state.selectedRole == UserRole.freelancer
                                        ? "freelancer"
                                        : "client",
                              );
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
                                AppLocalizations.of(
                                  context,
                                )!.alreadyHaveAccount,
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
                                  Navigator.pushNamed(
                                    context,
                                    RoutesManager.login,
                                    arguments:
                                        state.selectedRole ==
                                                UserRole.freelancer
                                            ? "freelancer"
                                            : "client",
                                  );
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.login,
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
        },
      ),
    );
  }
}
