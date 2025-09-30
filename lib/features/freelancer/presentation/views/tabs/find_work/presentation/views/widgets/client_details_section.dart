import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/features/profile/domain/entities/user_info_entity/user_info_entity.dart';
import 'package:taskly/features/profile/presentation/manager/profile_view_model/profile_view_model.dart';
import 'package:taskly/features/profile/presentation/manager/profile_view_model/profile_view_model_states.dart';

import '../../../../../../../../../config/routes/routes_manager.dart';
import '../../../../../../../../../core/di/di.dart';
import 'client_details_shimmer.dart';

class ClientDetailsSection extends StatelessWidget {
  const ClientDetailsSection({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      getIt<ProfileViewModel>()
        ..getUserInfo(
            userId,
            "client"
        ),
      child: BlocBuilder<ProfileViewModel, ProfileViewModelStates>(
        builder: (context, state) {
          if (state is ProfileViewModelStatesLoading) {
            return const ClientDetailsShimmer();
          } else if (state is ProfileViewModelStatesError) {
            return const ClientDetailsShimmer();
          } else if (state is ProfileViewModelStatesSuccess) {
            final UserInfoEntity client = state.userInfoEntity;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Text(
                  "Client Details",
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RoutesManager.reviewsView,
                      arguments: {
                        "userId": userId,
                        "role": "client",
                        "userRating": client.rating,
                        "userName": client.fullName,
                        "userImage": client.profileImage,
                      },
                    );
                    },
                  child: Row(
                children: [
                CircleAvatar(
                radius: 30.r,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: client.profileImage != null
                      ? NetworkImage(client.profileImage!)
                      : const AssetImage(Assets.assetsUserAvatar)
                  as ImageProvider,
                ),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (client.fullName != null && client.fullName!.isNotEmpty)
                          ? client.fullName!
                          : "Unknown Client",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(CupertinoIcons.star_fill, color: Colors.amber,
                          size: 16.sp,),
                        SizedBox(width: 4.h),
                        Text(
                          "${client.rating ?? 0.0}",
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Text(
                          " ${client.jobsCount} jobs posted",
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          ],
          );
          }

          return const SizedBox.shrink
          (
          );
        },
      ),
    );
  }
}
