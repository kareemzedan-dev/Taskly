import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/widgets/custom_search_text_field.dart';
import 'package:taskly/features/client/presentation/cubit/client_info_view_model/client_info_view_model.dart';
import 'package:taskly/features/client/presentation/cubit/client_info_view_model/client_info_view_model_states.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/cubit/services_view_model/services_view_model.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/user_info_home_header.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/service_category_grid_view.dart';

class ClientHomeTabViewBody extends StatefulWidget {
  const ClientHomeTabViewBody({super.key});

  @override
  State<ClientHomeTabViewBody> createState() => _ClientHomeTabViewBodyState();
}

 
class _ClientHomeTabViewBodyState extends State<ClientHomeTabViewBody> {
  late final ClientInfoViewModel _userInfoViewModel;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _userInfoViewModel = getIt<ClientInfoViewModel>();
    _userInfoViewModel.loadUserInfo();

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
              child: BlocBuilder<ClientInfoViewModel, ClientInfoViewModelStates>(
                builder: (context, state) {
                  if (state is ClientInfoViewModelLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is ClientInfoViewModelSuccess) {
                    return UserInfoHomeHeader(
                      fullName: state.userInfoEntity.fullName,
                    );
                  } else if (state is ClientInfoViewModelError) {
                    return Text(state.errorMessage);
                  }
                  return Container();
                },
              ),
            ),
            SizedBox(height: 30.h),

           
            CustomSearchTextField(
              hintTexts:_userInfoViewModel.searchHintTexts,
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
