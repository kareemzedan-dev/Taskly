import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/shared/presentation/views/widgets/custom_states_container.dart';

class OrderStatusCard extends StatelessWidget {
  final double price;
  final String status;
  final VoidCallback onButtonPressed;

  const OrderStatusCard({
    super.key,
    required this.price,
    required this.status,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey.shade100,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Total Price: \$${price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(width: 8.w),

                CustomStatesContainer(),
              ],
            ),
            ElevatedButton(
              onPressed: onButtonPressed,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  ColorsManager.primary,
                ),
              ),
              child: Text(
                "Submit Delivery",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
