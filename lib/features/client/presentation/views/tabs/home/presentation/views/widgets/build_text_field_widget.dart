  import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextField buildTextField(String  ? hintText  , int maxLines, TextEditingController controller) {
    return TextField(
      controller:controller ,
              maxLines: maxLines,

              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                hintText: hintText,
                hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
            );
  }