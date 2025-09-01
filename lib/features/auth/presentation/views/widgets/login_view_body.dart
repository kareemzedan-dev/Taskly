import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/core/utils/routes_manager.dart';
import 'package:taskly/core/widgets/custom_button.dart';
import 'package:taskly/core/widgets/custom_text_field.dart';
import 'package:taskly/core/widgets/or_divider.dart';
import 'package:taskly/features/auth/presentation/views/widgets/social_login_button.dart';
import 'package:taskly/l10n/app_localizations.dart';

class LoginViewBody extends StatelessWidget {
  LoginViewBody({super.key, required this.role});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final String role;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Taskly",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: ColorsManager.primary,
                  fontSize: 30.sp,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Center(
              child: Text(
                AppLocalizations.of(context)!.welcomeBack,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 20.sp,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 32.h),

            /// Email
            CustomTextFormField(
              prefixIcon: Icon(CupertinoIcons.mail),
              hintText:   AppLocalizations.of(context)!.email,
              textEditingController: emailController,
              validator: (p0) => p0!.isEmpty ? 'This field is required' : null,
              keyboardType: TextInputType.emailAddress,
              onSaved: (p0) {
                emailController.text = p0!;
              },
            ),
            SizedBox(height: 24.h),

            /// Password
            CustomTextFormField(
              prefixIcon: Icon(CupertinoIcons.lock),
              hintText: AppLocalizations.of(context)!.password,
              textEditingController: passwordController,
              iconShow: true,
              validator: (p0) => p0!.isEmpty ? 'This field is required' : null,
              keyboardType: TextInputType.visiblePassword,
              onSaved: (p0) {
                passwordController.text = p0!;
              },
            ),

            SizedBox(height: 20.h),
            OrDivider(),
            SizedBox(height: 20.h),

            /// Google button
            SocialLoginButton(
              label: AppLocalizations.of(context)!.continueWithGoogle,
              iconPath: Assets.assetsImagesIcGoogle,
              onPressed: () {},
            ),

            SizedBox(height: 48.h),

            /// Login button
            CustomBotton(title:  AppLocalizations.of(context)!.login, ontap: () {}),

            SizedBox(height: 5.h),

            /// Sign up link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                   AppLocalizations.of(context)!.dontHaveAccount,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    role == "freelancer"
                        ? Navigator.pushNamed(
                          context,
                          RoutesManager.register,
                          arguments: "freelancer",
                        )
                        : Navigator.pushNamed(
                          context,
                          RoutesManager.register,
                          arguments: "client",
                        );
                  },
                  child: Text(
                   AppLocalizations.of(context)!.signUp,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: ColorsManager.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
