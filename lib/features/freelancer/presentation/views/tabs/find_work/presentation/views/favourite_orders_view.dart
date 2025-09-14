import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/favourite_orders_view_body.dart';

class FavouriteOrdersView extends StatelessWidget {
  const FavouriteOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: Text(
          'Favourite Orders',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
        bottom:  PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade300, height: 1.0),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(CupertinoIcons.back, color: Colors.black),
        ),
        

      ),
      backgroundColor: Colors.white,
      body: SafeArea(child: FavouriteOrdersViewBody()),
    );
  }
}