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

import '../../../../../../../../../config/l10n/app_localizations.dart';
import '../../../../../../../../../core/helper/get_local_services.dart';



class ServiceCategoryGridView extends StatelessWidget {
  const ServiceCategoryGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final services = getLocalServices(local);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      child: services.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              child: Lottie.asset("assets/lotties/empty.json"),
            ),
            const SizedBox(height: 16),
            Text(
              local.noServicesFound,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      )
          : GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: services.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,

          mainAxisSpacing: 16.h,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, index) {
          final service = services[index];
          return AspectRatio(
            aspectRatio: 0.8,
            child: ServiceCategory(
              serviceEntity: service,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RoutesManager.serviceOrderView,
                  arguments: {
                    'title': service.title,
                    'category': service.key,
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}