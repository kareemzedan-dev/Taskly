// import 'package:flutter/material.dart';
// import 'package:talabat/core/utils/assets_manager.dart';
// import 'package:talabat/core/utils/routes_manager.dart';
// import 'package:talabat/features/welcome/presentation/views/widgets/social_login_button.dart';

// class SocialLoginOptions extends StatelessWidget {
//   const SocialLoginOptions({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SocialLoginButton(
//           label: "Continue with Google",
//           iconPath: Assets.assetsImagesIcGoogle,
//           onPressed: () {
//             Navigator.pushNamed(context, RoutesManager.home);
//           },
//         ),
//         SizedBox(height: 16),
//         SocialLoginButton(
//           label: "Continue with Apple",
//           iconPath: Assets.assetsImagesIcApple,
//           onPressed: () {
//             print("Apple login");
//           },
//         ),
//         SizedBox(height: 16),
//         SocialLoginButton(
//           label: "Continue with Facebook",
//           iconPath: Assets.assetsImagesIcFacebook,
//           onPressed: () {
//             print("Facebook login");
//           },
//         ),
//         SizedBox(height: 16),
//         SocialLoginButton(
//           label: "Continue with email",
//           iconPath: Assets.assetsImagesIcBaselineEmail,
//           onPressed: () {
//             Navigator.pushNamed(context, RoutesManager.loginWithEmail);
//           },
//         ),
//       ],
//     );
//   }
// }
