import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/payments/presentation/widgets/secure_payment_bannar.dart';

import '../../../../core/utils/assets_manager.dart';

class ClientPaymentsViewBody extends StatelessWidget {
  const ClientPaymentsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            children: [
              SecurePaymentBanner(),
              SizedBox(height: 16.h),

              Card(elevation: 6,child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: ColorsManager.primary.withOpacity(0.2),
                ),
                child: Column(children: [
                  Row(children: [
                    Image.asset(Assets.bankAccount,height: 24.h,width: 24.w,),
                    SizedBox(width: 16.w),
                   Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                     Text('IBAN Number',style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                       fontWeight: FontWeight.w600,
                       fontSize: 12.sp,
                     ),),

                       Text('SA56000000000000000000000000',style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                         fontWeight: FontWeight.w600,
                         fontSize: 14.sp,
                       ))
                   ],),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.all(4.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: ColorsManager.primary,
                      ),
                      child: Center(child: Icon(Icons.copy,color: Colors.white,size: 20.sp,),),
                    )
                  ],)

                ],),
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
