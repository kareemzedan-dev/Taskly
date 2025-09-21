
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/payments/presentation/widgets/bank_info_raw.dart';

class BankDetailsCard extends StatelessWidget {
  const BankDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: ColorsManager.primary.withOpacity(0.2),
        ),
        child: Column(
          children: [
            BankInfoRow(
              label: 'IBAN Number',
              number: 'SA5010000011100367531805',
              assetPath: Assets.assetsImagesBankAccount,
              onCopy: () {},
            ),
            SizedBox(height: 16.h),
            Divider(
              thickness: 1,
              color: ColorsManager.primary.withOpacity(0.2),
            ),
            SizedBox(height: 16.h),
            BankInfoRow(
              label: 'Account Number',
              number: '11100367531805',
              assetPath: Assets.assetsImagesAccountNumber,
              onCopy: () {},
            ),
            SizedBox(height: 16.h),
            Divider(
              thickness: 1,
              color: ColorsManager.primary.withOpacity(0.2),
            ),
            SizedBox(height: 16.h),
            BankInfoRow(
              label: 'Account Name',
              number: 'SA5010000011100367531805',
              assetPath: Assets.assetsImagesUser12366536,
              onCopy: () {},
            ),
            SizedBox(height: 16.h),
            Divider(
              thickness: 1,
              color: ColorsManager.primary.withOpacity(0.2),
            ),
            SizedBox(height: 16.h),
            BankInfoRow(
              label: 'SWIFT Code',
              number: 'NCBKSAJE',
              assetPath: Assets.assetsImagesSwiftCode,
              onCopy: () {},
            ),
          ],
        ),
      ),
    );
  }
}