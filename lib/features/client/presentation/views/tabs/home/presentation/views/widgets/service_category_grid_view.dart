import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/utils/routes_manager.dart';
import 'package:taskly/features/client/domain/entities/home/service_response_entity.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/cubit/services_view_model/services_view_model.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/cubit/services_view_model/services_view_model_states.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/service_category.dart';

class ServiceCategoryGridView extends StatelessWidget {
  const ServiceCategoryGridView({super.key});

  @override
  Widget build(BuildContext context) {
 

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: BlocBuilder<ServicesViewModel, ServicesViewModelStates>(
        builder: (context, state) {
          if (state is ServicesViewModelStatesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ServicesViewModelStatesSuccess) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.services.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                return ServiceCategory(
                  serviceEntity: state.services[index],

                  onTap: () {
                    Navigator.pushNamed(context, RoutesManager.serviceOrderView);
                  },
                );
              },
            );
          }
          if (state is ServicesViewModelStatesError) {
            return Center(child: Text(state.error));
          }

          return Container();
        },
      ),
    );
  }
}
