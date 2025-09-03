import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/send_offer_view_body.dart';

class SendOfferView extends StatelessWidget {
  const SendOfferView({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent, 
        backgroundColor: Colors.white,
        title: Text(
          'Send Offer',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(CupertinoIcons.back, color: Colors.black)),

      ),
      backgroundColor: Colors.white,
      body: SendOfferViewBody(),
    );
  }
}