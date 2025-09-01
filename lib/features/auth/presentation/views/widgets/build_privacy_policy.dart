import 'package:flutter/material.dart';
import 'package:taskly/core/utils/colors_manger.dart';

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
                  text: 'By creating an account you agree to the ',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: 'privacy policy',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ColorsManager.primary,
                  ),
                ),
                TextSpan(
                  text: ' and\nto the ',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: 'terms of use',
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
