import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/app_text_styles.dart';
import 'package:taskly/core/utils/colors_manger.dart';

import '../../config/l10n/app_localizations.dart';

class CustomTextFormField extends StatefulWidget {
  CustomTextFormField({
    super.key,
    required this.hintText,
    this.iconShow = false,
    required this.keyboardType,
    this.onSaved,
    this.validator,
    this.isEmailValidator = false,
    this.textEditingController,
    this.autovalidateMode,
    this.prefixIcon
  });

  final String? hintText;
  final bool iconShow;
  final TextInputType keyboardType;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final bool isEmailValidator;
  TextEditingController? textEditingController ;
  AutovalidateMode? autovalidateMode;
  Widget ? prefixIcon ;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool iconVisible = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        color: Colors.black,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      autovalidateMode: widget.autovalidateMode,
      controller: widget.textEditingController,
      obscureText: widget.iconShow ? !iconVisible : false,
      onSaved: widget.onSaved,
      validator: widget.isEmailValidator
          ? (value) => widget.validator!(value)
          : (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.thisFieldIsRequired;
        }
        return null;
      },
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        fillColor: ColorsManager.white,
        filled: true,
        contentPadding: const EdgeInsets.all(16.0),
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Colors.black54, // ✅ لون الهنت
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.iconShow
            ? GestureDetector(
          onTap: () {
            setState(() {
              iconVisible = !iconVisible;
            });
          },
          child: Icon(
            iconVisible ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xFFC9CECF),
          ),
        )
            : null,
        border: buildBorder(Colors.grey),
        enabledBorder: buildBorder(Colors.grey),
        focusedBorder: buildBorder(Colors.blue),
        errorBorder: buildBorder(Colors.red),
        focusedErrorBorder: buildBorder(Colors.red),
      ),
    ) ;

  }

  OutlineInputBorder buildBorder( Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color),
    );
  }
}
