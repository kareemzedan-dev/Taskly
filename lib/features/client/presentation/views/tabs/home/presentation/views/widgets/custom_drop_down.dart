import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String hint;
  final Function(String?) onChanged;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint = "Select Option",
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      isExpanded: true,
      hint: Text(
        hint,
        style: TextStyle(fontSize: 16.sp),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: TextStyle(fontSize: 16.sp)),
            ),
          )
          .toList(),
      value: value,
      onChanged: onChanged,
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(height: 48),
    );
  }
}
