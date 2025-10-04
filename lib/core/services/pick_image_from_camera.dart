import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  static Future<String?> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        print('📸 Image path: ${image.path}');
        return image.path; // رجع المسار
      }
    } catch (e) {
      print('❌ Error picking image: $e');
    }

    return null;
  }
}
