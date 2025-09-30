import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/view_model/place_order_view_model/place_order_view_model.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/custom_drop_down.dart';

class CategoryDropDown extends StatefulWidget {
  const CategoryDropDown({super.key,required this.selectedCategory});
final   String? selectedCategory;

  @override
  State<CategoryDropDown> createState() => _CategoryDropDownState();
}

class _CategoryDropDownState extends State<CategoryDropDown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: CustomDropdown(
        value: context.read<PlaceOrderViewModel>().selectedCategory,
        items: context.read<PlaceOrderViewModel>().categories,

        hint: widget.selectedCategory ?? "Select Category",
        onChanged: (value) {
          setState(() {
            context.read<PlaceOrderViewModel>().selectedCategory = value ?? widget.selectedCategory;
          });
        },
      ),
    );
  }
}
