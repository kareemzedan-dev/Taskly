
import 'package:flutter/material.dart';
import 'package:taskly/features/auth/presentation/views/widgets/social_login_button.dart';

import '../../../../../config/l10n/app_localizations.dart';
import '../../../../../core/utils/assets_manager.dart';


class SocialLoginOptions extends StatelessWidget {
  const SocialLoginOptions({
    super.key,

    required this.onGoogleLogin,
    required this.onAppleLogin,
    required this.onFacebookLogin,
  });
  final Function() onGoogleLogin;
  final Function() onAppleLogin;
  final Function() onFacebookLogin;

  @override
  Widget build(BuildContext context) {
    final local =AppLocalizations.of(context)!;
    return Column(
      children: [
        SocialLoginButton(
          label: local.continueWithGoogle,
          iconPath: Assets.assetsImagesIcGoogle,
          onPressed:onGoogleLogin
        ),
        SizedBox(height: 16),
        SocialLoginButton(
          label: "Login with Apple",
          iconPath: Assets.assetsImagesIcApple,
          onPressed:onAppleLogin
        ),
        SizedBox(height: 16),
        SocialLoginButton(
          label:  "Login with Facebook",
          iconPath: Assets.assetsImagesIcFacebook,
          onPressed: onFacebookLogin
        ),
      ],
    );
  }
}
