import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:taskly/core/components/dismissible_error_card.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/config/routes/routes_manager.dart';
import 'package:taskly/core/components/custom_button.dart';
import 'package:taskly/core/components/custom_text_field.dart';
import 'package:taskly/core/components/or_divider.dart';
import 'package:taskly/features/auth/presentation/cubit/auth_states.dart';
import 'package:taskly/features/auth/presentation/cubit/auth_view_model.dart';
import 'package:taskly/features/auth/presentation/views/widgets/social_login_button.dart';
import 'package:taskly/config/l10n/app_localizations.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key, required this.role});
  final String role;

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  AuthViewModel authViewModel = getIt<AuthViewModel>();
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthViewModel, AuthStates>(
      listener: (context, state) {
        if (state is AuthLoginLoadingState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (_) => Center(
                  child: LoadingAnimationWidget.threeRotatingDots(
                    size: 60,
                    color: ColorsManager.primary,
                  ),
                ),
          );
        }
        if (state is! AuthLoginLoadingState) {
          Navigator.pop(context);
        }
        if (state is AuthLoginSuccessState) {
          if(widget.role == 'client'){
                showTemporaryMessage(context, "Login successfully", MessageType.success);

            Navigator.pushNamedAndRemoveUntil(context, RoutesManager.clientHome, (_) => false);
          }else{
               showTemporaryMessage(context, "Login successfully", MessageType.success);
            Navigator.pushNamedAndRemoveUntil(context, RoutesManager.freelancerHome, (_) => false);
            
          }
       
        }
        if (state is AuthLoginErrorState) {
      showTemporaryMessage(context, state.error, MessageType.error);
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: authViewModel.formKey,
            autovalidateMode: authViewModel.autovalidateMode,
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
                
                 CustomTextFormField(
                  prefixIcon: Icon(CupertinoIcons.mail),
                  hintText: AppLocalizations.of(context)!.email,
                  textEditingController: authViewModel.emailController,
                  validator:
                      (p0) => p0!.isEmpty ? 'This field is required' : null,
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (p0) {
                    authViewModel.emailController.text = p0!;
                  },
                ),
                SizedBox(height: 24.h),

          
                CustomTextFormField(
                  prefixIcon: Icon(CupertinoIcons.lock),
                  hintText: AppLocalizations.of(context)!.password,
                  textEditingController: authViewModel.passwordController,
                  iconShow: true,
                  validator:
                      (p0) => p0!.isEmpty ? 'This field is required' : null,
                  keyboardType: TextInputType.visiblePassword,
                  onSaved: (p0) {
                    authViewModel.passwordController.text = p0!;
                  },
                ),

                SizedBox(height: 20.h),
                OrDivider(),
                SizedBox(height: 20.h),

                SocialLoginButton(
                  label: AppLocalizations.of(context)!.continueWithGoogle,
                  iconPath: Assets.assetsImagesIcGoogle,
                  onPressed: () {},
                ),

                SizedBox(height: 48.h),

                CustomButton(
                  title: AppLocalizations.of(context)!.login,
                  ontap: () {
                    if (authViewModel.formKey.currentState!.validate()) {
                      context.read<AuthViewModel>().loginUser(
                        email: authViewModel.emailController.text,
                        password: authViewModel.passwordController.text,
                        role: widget.role,
                      );
                    } else {
                      setState(() {
                        authViewModel.autovalidateMode =
                            AutovalidateMode.onUserInteraction;
                      });
                    }
                  },
                ),

                SizedBox(height: 5.h),

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
                    SizedBox(width: 5.w,),
                    GestureDetector(
                      onTap: () {
                           widget.role == "freelancer"
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
        ),
      ),
    );
  }
}
