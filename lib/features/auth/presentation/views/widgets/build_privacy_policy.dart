import 'package:flutter/material.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/config/l10n/app_localizations.dart';

class PrivacyPolicyWithCheck extends FormField<bool> {
  PrivacyPolicyWithCheck({super.key})
      : super(
          initialValue: false,
          validator: (value) {
            if (value == false) {
              return "error";  
            }
            return null;
          },
          builder: (state) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: state.value ?? false,
                  activeColor: ColorsManager.primary,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: BorderSide(
                    color: state.hasError ? Colors.red : Colors.grey,  
                    width: 2,
                  ),
                  onChanged: (value) {
                    state.didChange(value);
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(state.context)!.privacyPolicyAgreement,
                          style: Theme.of(state.context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: AppLocalizations.of(state.context)!.privacyPolicy,
                          style: Theme.of(state.context).textTheme.bodyMedium?.copyWith(
                                color: ColorsManager.primary,
                              ),
                        ),
                        TextSpan(
                          text: AppLocalizations.of(state.context)!.termsAgreement,
                          style: Theme.of(state.context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: AppLocalizations.of(state.context)!.termsOfUse,
                          style: Theme.of(state.context).textTheme.bodyMedium?.copyWith(
                                color: ColorsManager.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
}
