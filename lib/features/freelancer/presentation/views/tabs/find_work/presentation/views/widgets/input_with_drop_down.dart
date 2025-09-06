
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputWithDropdown extends StatelessWidget {
  final String hint;
  final String selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const InputWithDropdown({
    super.key,
    required this.hint,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2.w,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          DropdownButton2<String>(
            value: selectedValue,
            underline: const SizedBox(),
            isExpanded: false,
            items: items
                .map((val) => DropdownMenuItem(
                      value: val,
                      child: Text(val),
                    ))
                .toList(),
            onChanged: onChanged,
            buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              height: 40.h,
              width: 100.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade200,
              ),
            ),
            menuItemStyleData: MenuItemStyleData(height: 40.h),
          ),
        ],
      ),
    );
  }
}
