import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/components/custom_button.dart';
import 'package:taskly/core/components/custom_text_field.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/profile/presentation/views/widgets/wallet_card.dart';

class WithdrawalRequestTabContent extends StatefulWidget {
  const WithdrawalRequestTabContent({super.key});

  @override
  State<WithdrawalRequestTabContent> createState() =>
      _WithdrawalRequestTabContentState();
}

class _WithdrawalRequestTabContentState
    extends State<WithdrawalRequestTabContent> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? selectedMethod; // "vodafone" or "instapay"

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WalletCard(
              availableBalance: "\$1200",
              totalEarnings: "\$3000",
              withdrawn: "\$1800",
            ),
            SizedBox(height: 20.h),

            /// Amount Section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Withdrawal Amount",
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    CustomTextFormField(
                      hintText: "Enter Amount",
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),

            /// Payment Method Section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Payment Method",
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    /// Vodafone
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMethod = "vodafone";
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                selectedMethod == "vodafone"
                                    ? ColorsManager.primary
                                    : Colors.grey.shade300,
                            width: selectedMethod == "vodafone" ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: RadioListTile<String>(
                          value: "vodafone",
                          groupValue: selectedMethod,
                          activeColor: ColorsManager.primary,
                          onChanged: (value) {
                            setState(() {
                              selectedMethod = value;
                            });
                          },
                          title: Row(
                            children: [
                              const Icon(
                                Icons.account_balance_wallet_outlined,
                                color: Colors.red,
                              ),
                              SizedBox(width: 8.w),
                              const Text("Vodafone Cash"),
                            ],
                          ),
                        ),
                      ),
                    ),

                    /// InstaPay
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMethod = "instapay";
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                selectedMethod == "instapay"
                                    ? ColorsManager.primary
                                    : Colors.grey.shade300,
                            width: selectedMethod == "instapay" ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: RadioListTile<String>(
                          value: "instapay",
                          groupValue: selectedMethod,
                          activeColor: ColorsManager.primary,
                          onChanged: (value) {
                            setState(() {
                              selectedMethod = value;
                            });
                          },
                          title: Row(
                            children: [
                              const Icon(
                                Icons.account_balance,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 8.w),
                              const Text("InstaPay"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mobile Number",
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.phone_android,
                          color: ColorsManager.primary,
                        ),
                        hintText: "Enter mobile number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: ColorsManager.primary),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      "⚠️ Please enter the Vodafone Cash number registered in your name",
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30.h),

            CustomButton(title: "Submit Request", ontap: () {}),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
