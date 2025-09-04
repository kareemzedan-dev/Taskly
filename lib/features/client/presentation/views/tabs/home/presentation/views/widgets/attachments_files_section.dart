import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/services/file_uploaded_services.dart';
import 'package:taskly/core/utils/app_text_styles.dart';

class AttachmentsFilesSection extends StatefulWidget {
  final Function(List<File>)? onFilesSelected;  

  const AttachmentsFilesSection({super.key, this.onFilesSelected});

  @override
  State<AttachmentsFilesSection> createState() => _AttachmentsFilesSectionState();
}

class _AttachmentsFilesSectionState extends State<AttachmentsFilesSection> {
  final FilePickerService _filePickerService = FilePickerService();
  List<File>? selectedFiles;

  void pickFiles() async {
    List<File>? files = await _filePickerService.pickMultipleFiles();
    if (files != null && files.isNotEmpty) {
      setState(() {
        selectedFiles = files;
      });
      widget.onFilesSelected?.call(files);  
      print("Selected files: ${files.map((f) => f.path)}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.attach_file, color: Colors.grey),
          onPressed: pickFiles,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: GestureDetector(
            onTap: pickFiles,
            child: Container(
              height: 50.h,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Center(
                child: Text(
                  selectedFiles == null || selectedFiles!.isEmpty
                      ? "You can attach files or images here"
                      : "${selectedFiles!.length} file(s) selected",
                  style: AppTextStyles.bold16.copyWith(color: Colors.grey),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
