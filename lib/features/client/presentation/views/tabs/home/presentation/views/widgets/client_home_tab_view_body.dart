import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/widgets/custom_search_text_field.dart';
import 'package:taskly/features/client/presentation/cubit/user_view_model/user_info_view_model.dart';
import 'package:taskly/features/client/presentation/cubit/user_view_model/user_info_view_model_states.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/cubit/services_view_model/services_view_model.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/client_home_header.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/service_category_grid_view.dart';

class ClientHomeTabViewBody extends StatefulWidget {
  const ClientHomeTabViewBody({super.key});

  @override
  State<ClientHomeTabViewBody> createState() => _ClientHomeTabViewBodyState();
}

final List<String> searchHintTexts = [
  "Find top freelancers",
  "Search by category",
  "Discover trending jobs",
  "Explore recent projects",
  "Search by skill or service",
];

class _ClientHomeTabViewBodyState extends State<ClientHomeTabViewBody> {
  late final UserInfoViewModel _userInfoViewModel;

  @override
  void initState() {
    super.initState();
    _userInfoViewModel = getIt<UserInfoViewModel>();
    _userInfoViewModel.loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BlocProvider(
              create: (context) => _userInfoViewModel,
              child: BlocBuilder<UserInfoViewModel, UserInfoViewModelStates>(
                builder: (context, state) {
                  if (state is UserInfoViewModelLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is UserInfoViewModelSuccess) {
                    return UserInfoHomeHeader(
                      fullName: state.userInfoEntity.fullName,
                    );
                  } else if (state is UserInfoViewModelError) {
                    return Text(state.errorMessage);
                  }
                  return Container();
                },
              ),
            ),
            SizedBox(height: 30.h),
            CustomSearchTextField(hintTexts: searchHintTexts),
            SizedBox(height: 30.h),
            ServiceCategoryGridView(),
          ],
        ),
      ),
    );
  }
}
