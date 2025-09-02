import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class EmptyStateAnimation extends StatelessWidget {
  final String animationPath;
  final String message;

  const EmptyStateAnimation({
    super.key,
    required this.animationPath,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            animationPath,
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style:   TextStyle(
              fontSize: 18.sp,
            
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
