import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/config/l10n/app_localizations.dart';
import 'package:taskly/config/routes/routes_manager.dart';
import 'package:taskly/core/cache/shared_preferences.dart';
import 'package:taskly/core/components/custom_button.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/utils/strings_manager.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/view_model/place_order_view_model/place_order_view_model.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/category_drop_down.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/description_box.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/hiring_methods_options.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/private_hire_section.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/time_input_raw.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/attachments_files_section.dart';
import 'package:taskly/features/profile/presentation/manager/profile_view_model/profile_view_model.dart';
import '../../../../../../../../../core/components/custom_alert_dialog.dart';
import '../../../../../../../../../core/components/custom_text_field.dart';
import '../../../../../../../../profile/presentation/manager/profile_view_model/profile_view_model_states.dart';
import '../../../../../../../../../core/components/dismissible_error_card.dart';

class OrderFormSection extends StatelessWidget {
  final int selectedHireMethodIndex;
  final ValueChanged<int> onHireMethodChanged;
  final VoidCallback onSubmit;

  const OrderFormSection({
    super.key,
    required this.selectedHireMethodIndex,
    required this.onHireMethodChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final viewModel = context.read<PlaceOrderViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, local.title_label),
        SizedBox(height: 16.h),
        CustomTextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return "ادخل العنوان";
            }
            return null;
          },
          keyboardType: TextInputType.text,
          hintText: "ادخل العنوان",
          textEditingController: viewModel.titleController,
        ),
        SizedBox(height: 28.h),
        _buildLabel(context, local.category_label),
        SizedBox(height: 16.h),
        CategoryDropDown(selectedCategory: viewModel.selectedCategory ?? ''),
        SizedBox(height: 28.h),
        _buildLabel(context, local.description_label),
        SizedBox(height: 16.h),
        const DescriptionBox(),
        SizedBox(height: 28.h),
        _buildLabel(context, local.deadline_label),
        SizedBox(height: 16.h),
        const TimeInputRaw(),
        SizedBox(height: 28.h),
        _buildLabel(context, local.attachments_label),
        SizedBox(height: 16.h),
        AttachmentsFilesSection(
          uploadOrderAttachmentsViewModel: viewModel.uploadOrderAttachmentsViewModel,
        ),
        SizedBox(height: 28.h),
        _buildLabel(context, local.hiring_method_label),
        SizedBox(height: 16.h),
        HiringMethodsOptions(
          selectedIndex: selectedHireMethodIndex,
          onChanged: onHireMethodChanged,
        ),
        if (selectedHireMethodIndex == 1)
          PrivateHireSection(selectedId: viewModel.freelancerId),
        SizedBox(height: 28.h),

        // BlocProvider للتحكم في حالة الزر حسب حالة المستخدم
        BlocProvider(
          create: (context) => getIt<ProfileViewModel>()
            ..getUserInfo(
              SharedPrefHelper.getString(StringsManager.idKey)!,
              "client",
            ),
          child: BlocListener<ProfileViewModel, ProfileViewModelStates>(
            listener: (context, state) {
              if (state is ProfileViewModelStatesSuccess &&
                  state.userInfoEntity.clientStatus != "Active") {
                showDialog(
                  context: context,
                  builder: (_) => CustomAlertDialog(
                    title: "تحذير",
                    content:
                    "انت مقيد مؤقتًا من نشر الطلبات. يمكنك التواصل مع الدعم الآن لحل المشكلة.",
                    positiveButtonText: "تواصل مع الدعم",
                    onPositivePressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        RoutesManager.adminChatView,
                        arguments: {
                          "currentUserId": SharedPrefHelper.getString(StringsManager.idKey),

                        },

                      );
                    },
                    negativeButtonText: "إلغاء",
                    onNegativePressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    lottieAsset: "assets/lotties/alert.json",
                    leadingIcon: Icons.security,
                    leadingIconColor: Colors.orange,
                    warningLabel: "انتباه",
                    warningColor: Colors.red,
                  ),
                );

              }
            },
            child: BlocBuilder<ProfileViewModel, ProfileViewModelStates>(
              builder: (context, state) {
                bool isActive = false;

                if (state is ProfileViewModelStatesSuccess) {
                  isActive = state.userInfoEntity.clientStatus == "Active";
                }

                return CustomButton(
                  title: isActive ? local.submit_button : "${local.submit_button} ...",
                  ontap: isActive ? onSubmit : () {},
                  isEnable: isActive,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 18.sp,
      ),
    );
  }
}
