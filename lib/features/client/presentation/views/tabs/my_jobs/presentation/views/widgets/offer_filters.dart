
 
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/colors_manger.dart';

class OffersFilters extends StatelessWidget {
  final List<String> filters;

  const OffersFilters({super.key, required this.filters});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Filter by:",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(width: 10.w),
        ...filters.map(
          (filter) => Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: FilterChip(
              label: Text(
                filter,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              selected: false,
              backgroundColor: ColorsManager.primary.withOpacity(.5),
              selectedColor: ColorsManager.primary.withOpacity(0.7),
              labelStyle: const TextStyle(color: Colors.white),
              onSelected: (bool selected) {},
            ),
          ),
        ),
      ],
    );
  }
}
