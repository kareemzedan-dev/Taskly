
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/colors_manger.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final bool filled;

  const ActionButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.filled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: filled ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        border: filled ? null : Border.all(color: color, width: 1.w),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: filled ? ColorsManager.white : color),
            SizedBox(width: 5.w),
            Center(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: filled ? ColorsManager.white : color,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
