import 'package:flutter/material.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/l10n/app_localizations.dart';

class PrivacyPolicyWithCheck extends StatefulWidget {
  const PrivacyPolicyWithCheck({super.key});

  @override
  State<PrivacyPolicyWithCheck> createState() => _PrivacyPolicyWithCheckState();
}

class _PrivacyPolicyWithCheckState extends State<PrivacyPolicyWithCheck> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Checkbox(
            value: isChecked,
            activeColor: ColorsManager.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: (value) {
              setState(() {
                isChecked = value ?? false;
              });
            },
          ),
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: AppLocalizations.of(context)!.privacyPolicyAgreement,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: AppLocalizations.of(context)!.privacyPolicy,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ColorsManager.primary,
                  ),
                ),
                TextSpan(
                  text: AppLocalizations.of(context)!.termsAgreement,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: AppLocalizations.of(context)!.termsOfUse,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ColorsManager.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
