import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskly/core/components/custom_button.dart';
import 'package:taskly/core/components/custom_text_field.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/features/profile/domain/entities/user_info_entity/user_info_entity.dart';
import 'package:taskly/features/reviews/presentation/widgets/user_avatar.dart';

Future<void> _pickImageFromCamera() async {
  final ImagePicker picker = ImagePicker();

  try {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      print('📸 Image path: ${image.path}');
      // هنا ممكن تعمل أي حاجة بالـ image.path
      // زي رفعها للسيرفر أو تحديث الصورة في UI
    }
  } catch (e) {
    print('❌ Error picking image: $e');
  }
}

class UserAccountViewBody extends StatelessWidget {
  const UserAccountViewBody({super.key, required this.userInfoEntity});

  final UserInfoEntity userInfoEntity;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Center(
              child: Stack(
                children: [
                  UserAvatar(
                    radius: 50.r,
                    imagePath: userInfoEntity.profileImage,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImageFromCamera,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.camera_alt,
                          size: 20.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "User Name",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
            ),
            SizedBox(height: 8.h),
            CustomTextFormField(
              hintText: "Enter User Name",
              keyboardType: TextInputType.name,
              textEditingController:
                  TextEditingController(text: userInfoEntity.fullName),
            ),
            SizedBox(height: 16.h),
            Text(
              "Email Address",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
            ),
            SizedBox(height: 8.h),
            CustomTextFormField(
              hintText: "Enter Email Address",
              keyboardType: TextInputType.name,
              textEditingController:
                  TextEditingController(text: userInfoEntity.email),
            ),
            SizedBox(height: 16.h),
            Text(
              "Phone Number",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
            ),
            SizedBox(height: 8.h),
            CustomTextFormField(
              hintText: "Enter Phone Number",
              keyboardType: TextInputType.name,
              textEditingController:
                  TextEditingController(text: userInfoEntity.phoneNumber),
            ),
            SizedBox(height: 50.h),
            CustomButton(
              title: "Save",
              ontap: () {},
            )
          ],
        ),
      ),
    );
  }
}
