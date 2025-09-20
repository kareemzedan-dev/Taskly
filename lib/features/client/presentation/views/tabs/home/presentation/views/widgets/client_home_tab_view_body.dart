import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/components/custom_search_text_field.dart';
import 'package:taskly/core/utils/strings_manager.dart';
import 'package:taskly/features/client/presentation/cubit/client_info_view_model/client_info_view_model.dart';
import 'package:taskly/features/client/presentation/cubit/client_info_view_model/client_info_view_model_states.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/cubit/services_view_model/services_view_model.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/user_info_home_header.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/service_category_grid_view.dart';
import 'package:taskly/features/profile/presentation/manager/profile_view_model/profile_view_model.dart';
import 'package:taskly/features/profile/presentation/manager/profile_view_model/profile_view_model_states.dart';

import '../../../../../../../../../core/cache/shared_preferences.dart';

class ClientHomeTabViewBody extends StatefulWidget {
  const ClientHomeTabViewBody({super.key});

  @override
  State<ClientHomeTabViewBody> createState() => _ClientHomeTabViewBodyState();
}

 
class _ClientHomeTabViewBodyState extends State<ClientHomeTabViewBody> {
  late final ProfileViewModel _userInfoViewModel;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _userInfoViewModel = getIt<ProfileViewModel>()..getUserInfo(SharedPrefHelper.getString(StringsManager.idKey)!, StringsManager.roleKey);
   // _userInfoViewModel.loadUserInfo();

    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    debugPrint("Searching for: $query");
    context.read<ServicesViewModel>().searchServices(query);
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
              child: BlocBuilder<ProfileViewModel, ProfileViewModelStates>(
                builder: (context, state) {
                  if (state is ProfileViewModelStatesLoading) {
                    return const UserInfoHomeHeaderShimmer();
                  } else if (state is ProfileViewModelStatesSuccess) {
                    return UserInfoHomeHeader(
                      fullName: state.userInfoEntity.fullName,
                    );
                  } else if (state is ProfileViewModelStatesError) {
                    return Text(state.message);
                  }
                  return Container();
                },
              ),
            ),
            SizedBox(height: 30.h),

           
            CustomSearchTextField(
              hintTexts:["Search for services"],
              controller: _searchController,
              onChanged: _onSearchChanged,  
            ),

            SizedBox(height: 30.h),
              ServiceCategoryGridView(),
          ],
        ),
      ),
    );
  }
}
