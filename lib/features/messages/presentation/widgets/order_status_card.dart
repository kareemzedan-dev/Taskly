import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/messages/presentation/widgets/custom_states_container.dart';

class OrderStatusCard extends StatelessWidget {
  final double price;
  final String status;
  final String message;
  final VoidCallback? onButtonPressed;
  final String? buttonText;

  const OrderStatusCard({
    super.key,
    required this.price,
    required this.status,
    required this.message,
    this.onButtonPressed,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey.shade100,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "Total Price: \$${price.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 16.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                CustomStatesContainer(state: status),
              ],
            ),
            SizedBox(height: 12.h),
            if (buttonText != null && onButtonPressed != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onButtonPressed,
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(ColorsManager.primary),
                    padding: WidgetStateProperty.all(
                        EdgeInsets.symmetric(vertical: 14.h)),
                  ),
                  child: Text(
                    buttonText!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
