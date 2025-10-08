import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskly/features/freelancer/domain/entities/offer_entity/offer_entity.dart';
import '../../../../../../../../../core/di/di.dart';
import '../../../../../../../../../core/utils/colors_manger.dart';
import '../../../../../../../../client/presentation/views/tabs/my_jobs/presentation/views/widgets/expandable_text.dart';
import '../../../../../../../../profile/presentation/widgets/user_info_section.dart';
import '../../../../../../../../profile/presentation/manager/profile_view_model/profile_view_model.dart';
import '../../../../../../../../profile/presentation/manager/profile_view_model/profile_view_model_states.dart';
import '../../../../../../../../client/presentation/views/tabs/profile/presentation/views/widgets/user_info_section_shimmer.dart';

class BaseOfferCard extends StatelessWidget {
  final OfferEntity offerEntity;
  final Widget? topWidget; // زي رسالة أو badge
  final Widget? bottomWidget; // زي Actions أو Delete button

  const BaseOfferCard({
    super.key,
    required this.offerEntity,
    this.topWidget,
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 2.w),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (topWidget != null) topWidget!,
              SizedBox(height: topWidget != null ? 8.h : 0),
              _buildUserInfo(context),
              SizedBox(height: 16.h),
              _buildTitleAndStatus(context),
              SizedBox(height: 8.h),
              _buildDescription(context), // دلوقتي هتستخدم ExpandableText
              SizedBox(height: 8.h),
              _buildAmountRow(context),
              if (bottomWidget != null) ...[
                SizedBox(height: 8.h),
                bottomWidget!,
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return BlocBuilder<ProfileViewModel, ProfileViewModelStates>(
      bloc: getIt<ProfileViewModel>()..getUserInfo(offerEntity.clientId, "client"),
      builder: (context, state) {
        if (state is ProfileViewModelStatesLoading || state is ProfileViewModelStatesError) {
          return const UserInfoSectionShimmer();
        }
        if (state is ProfileViewModelStatesSuccess) {
          return UserInfoSection(
            photoSizeSelected: true,
            name: state.userInfoEntity.fullName,
            email: state.userInfoEntity.email,
            rating: state.userInfoEntity.rating!,
            userInfo: state.userInfoEntity,
          );
        }
        return const Center(child: Text("Loading"));
      },
    );
  }

  Widget _buildTitleAndStatus(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            offerEntity.orderName ?? '',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: EdgeInsets.all(4.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: ColorsManager.primary.withOpacity(0.1),
            border: Border.all(color: ColorsManager.primary.withOpacity(0.1), width: 1.w),
          ),
          child: Text(
            offerEntity.offerStatus,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ColorsManager.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return ExpandableText(
      text: offerEntity.offerDescription ?? 'No description provided',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
    );
  }

  Widget _buildAmountRow(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.attach_money_outlined, size: 15.sp),
        Text(
          "${offerEntity.offerAmount} SAR",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
