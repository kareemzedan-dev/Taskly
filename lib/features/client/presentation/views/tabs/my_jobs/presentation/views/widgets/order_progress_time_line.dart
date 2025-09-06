import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/colors_manger.dart';

class OrderProgressTimeline extends StatelessWidget {
  final List<String> steps; 
  final int currentStep; 
  final Color activeColor;
  final Color inactiveColor;

  const OrderProgressTimeline({
    super.key,
    required this.steps,
    required this.currentStep,
    this.activeColor = ColorsManager.primary,
    this.inactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isEven) {
          int stepIndex = index ~/ 2;
          bool isActive = stepIndex <= currentStep;

          return Column(
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: isActive ? activeColor : inactiveColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    isActive ? Icons.check : Icons.circle_outlined,
                    size: 16.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                steps[stepIndex],
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isActive ? activeColor : inactiveColor,
                ),
              ),
            ],
          );
        } else {
          // الخط بين الدوائر
          int leftStep = index ~/ 2;
          bool isActive = leftStep < currentStep;

          return Expanded(
            child: Container(
              height: 2.h,
              color: isActive ? activeColor : inactiveColor.withOpacity(0.3),
            ),
          );
        }
      }),
    );
  }
}
