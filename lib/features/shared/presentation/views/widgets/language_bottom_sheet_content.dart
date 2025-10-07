import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/components/custom_button.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/core/utils/colors_manger.dart';

class LanguageBottomSheetContent extends StatefulWidget {
  final String? initialLanguage;

  const LanguageBottomSheetContent({super.key, this.initialLanguage});

  @override
  State<LanguageBottomSheetContent> createState() =>
      _LanguageBottomSheetContentState();
}

class _LanguageBottomSheetContentState
    extends State<LanguageBottomSheetContent> {
  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.initialLanguage;
  }

  @override
  Widget build(BuildContext context) {
    final languages = [
      {"title": "العربية", "icon": Assets.assetsImagesArabicFlag},
      {"title": "English", "icon": Assets.assetsImagesEnglishFlag},
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(12.w),
            itemCount: languages.length,
            separatorBuilder:
                (_, __) => const Divider(color: Colors.grey, thickness: 0.5),
            itemBuilder: (context, index) {
              final lang = languages[index];
              final isSelected = lang["title"] == _selectedLanguage;

              return ListTile(
                leading: Image.asset(lang["icon"]!, width: 30.w, height: 30.w),
                title: Text(
                  lang["title"]!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: ColorsManager.black,fontSize: 16.sp,),
                ),
                trailing: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: ColorsManager.black, width: 2),
                    color:
                        isSelected ? ColorsManager.primary : Colors.transparent,
                  ),
                  child:
                      isSelected
                          ? Icon(
                            Icons.done,
                            color: ColorsManager.white,
                            size: 16.sp,
                          )
                          : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedLanguage = lang["title"];
                  });
                },
              );
            },
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomButton(
              title: "Save",
              ontap: () {
                if (_selectedLanguage != null) {
                  Navigator.pop(context, _selectedLanguage);
                }
              },
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
