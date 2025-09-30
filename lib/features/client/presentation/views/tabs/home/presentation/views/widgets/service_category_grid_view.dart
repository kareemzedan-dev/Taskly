import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/config/routes/routes_manager.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/view_model/services_view_model/services_view_model.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/view_model/services_view_model/services_view_model_states.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/service_category.dart';
import 'package:shimmer/shimmer.dart';

class ServiceCategoryGridView extends StatelessWidget {
  ServiceCategoryGridView({super.key});

  final ServicesViewModel servicesViewModel = getIt<ServicesViewModel>();
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: BlocBuilder<ServicesViewModel, ServicesViewModelStates>(
        builder: (context, state) {
          if (state is ServicesViewModelStatesLoading) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 11,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  );
                },
              ),
            );
          }


          if (state is ServicesViewModelStatesSuccess) {
            if (state.services.isEmpty) {
               
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                      child: Lottie.asset("assets/lotties/empty.json"),
                    ),
                    const SizedBox(height: 16),
                      Text(
                      "No services found",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            }
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
                    Navigator.pushNamed(
                      context,
                      RoutesManager.serviceOrderView,
                      arguments: {
                        'title': state.services[index].title,
                        'category': servicesViewModel.categories[index],
                      },
                    );
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
