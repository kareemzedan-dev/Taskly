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
  List<File> selectedFiles = [];

  void pickFiles() async {
    List<File>? files = await _filePickerService.pickMultipleFiles();
    if (files != null && files.isNotEmpty) {
      setState(() {
        selectedFiles.addAll(files);
      });
      widget.onFilesSelected?.call(selectedFiles);
      print("Selected files: ${selectedFiles.map((f) => f.path)}");
    }
  }

  void removeFile(int index) {
    setState(() {
      selectedFiles.removeAt(index);
    });
    widget.onFilesSelected?.call(selectedFiles);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
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
                      selectedFiles.isEmpty
                          ? "You can attach files or images here"
                          : "${selectedFiles.length} file(s) selected",
                      style: AppTextStyles.bold16.copyWith(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: List.generate(selectedFiles.length, (index) {
            final file = selectedFiles[index];
            final fileName = file.path.split('/').last;
            return Chip(
              label: Text(fileName),
              deleteIcon: Icon(Icons.close, size: 18),
              onDeleted: () => removeFile(index),
            );
          }),
        ),
      ],
    );
  }
}
