import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/config/routes/routes_manager.dart';
import 'package:taskly/core/cache/shared_preferences.dart';
import 'package:taskly/core/components/custom_search_text_field.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/utils/strings_manager.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/cubit/get_order_view_model.dart/get_order_view_model.dart';
import 'package:taskly/features/shared/presentation/views/widgets/messages_card.dart';

import '../../../../client/presentation/views/tabs/my_jobs/presentation/cubit/get_order_view_model.dart/get_order_view_model_states.dart';

class UserMessagesTabViewBody extends StatelessWidget {
  const UserMessagesTabViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    bool hasMessages = true;  

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder< GetOrderViewModel, GetOrderViewModelStates>(

          bloc: getIt<GetOrderViewModel>()..getUserOrdersByUserId( SharedPrefHelper.getString(StringsManager.idKey)!, "freelancer"),
          builder: (context, state) {
            if(state is GetOrderViewModelStatesLoading){
              print("id is ${SharedPrefHelper.getString(StringsManager.idKey)!} ");

              return const Center(child: CircularProgressIndicator());
            }
            if(state is GetOrderViewModelStatesError){
              return Center(child: Text(state.message),);
            }
            if(state is GetOrderViewModelStatesSuccess){
              return Column(
                children: [
                  SizedBox(height: 16.h),

                  CustomSearchTextField(
                    hintTexts: ["Search messages_repos...", "Search contacts...", "Search groups..."],
                  ),

                  SizedBox(height: 40.h),

                  ListView.builder(
                      itemCount: state.orderEntity!.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder:(context, index) =>  Padding(
                        padding: const EdgeInsets.symmetric( vertical: 8.0),
                        child: MessagesCard(onTap: (){Navigator.pushNamed(context, RoutesManager.chatView);},order: state.orderEntity[index],),
                      )),
                ],
              );
            }
            return const Center(child: Text("No messages_repos"),);

          }
        ),
      ),
    );
  }
}
