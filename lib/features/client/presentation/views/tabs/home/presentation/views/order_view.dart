import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/view_model/place_order_view_model/place_order_view_model.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/order_view_body.dart';

import '../../../../../../../../config/l10n/app_localizations.dart';

class OrderView extends StatelessWidget {
  const OrderView({super.key,required this.title,required this.selectedCategory});
  final String? title ,selectedCategory;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(CupertinoIcons.back, ),
        ),
        title: Text(
          local.service_order,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        shape: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 2),
        ),
      ),


      body: BlocProvider(
        create: (context) => getIt<PlaceOrderViewModel>(),
        child: OrderViewBody(title:title!,selectedCategory:selectedCategory! ),
      ),
    );
  }
}
