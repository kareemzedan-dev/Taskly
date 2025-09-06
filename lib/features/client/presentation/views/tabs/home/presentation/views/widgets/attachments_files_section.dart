import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/services/file_uploaded_services.dart';
import 'package:taskly/core/utils/app_text_styles.dart';

class AttachmentsFilesSection extends StatefulWidget {
  final Function(List<File>)? onFilesSelected;
  final Map<String, double>? uploadProgress;
  final VoidCallback? onClearAll;

  const AttachmentsFilesSection({
    super.key, 
    this.onFilesSelected,
    this.uploadProgress,
    this.onClearAll,
  });

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
        selectedFiles.addAll(files); // أضف الجديد للقديم بدل الاستبدال
      });
      widget.onFilesSelected?.call(selectedFiles);
    }
  }

  void removeFile(int index) {
    setState(() {
      selectedFiles.removeAt(index);
    });
    widget.onFilesSelected?.call(selectedFiles);
  }

  void clearAllFiles() {
    setState(() {
      selectedFiles.clear();
    });
    widget.onFilesSelected?.call(selectedFiles);
    widget.onClearAll?.call();
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
            if (selectedFiles.isNotEmpty)
              IconButton(
                icon: Icon(Icons.clear_all, color: Colors.red),
                onPressed: clearAllFiles,
                tooltip: 'Clear all files',
              ),
          ],
        ),
        SizedBox(height: 10.h),
        Column(
          children: List.generate(selectedFiles.length, (index) {
            final file = selectedFiles[index];
            final fileName = file.path.split('/').last;
            final filePath = file.path;
            final progress = widget.uploadProgress?[filePath] ?? 0.0;
            
            return Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          fileName,
                          style: AppTextStyles.medium14,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (progress < 1.0)
                        SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 2,
                          ),
                        )
                      else
                        Icon(Icons.check_circle, color: Colors.green, size: 20),
                      SizedBox(width: 8.w),
                      IconButton(
                        icon: Icon(Icons.close, size: 18),
                        onPressed: () => removeFile(index),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  LinearProgressIndicator(
                    value: progress,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress < 1.0 ? Colors.blue : Colors.green,
                    ),
                    minHeight: 4.h,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    progress < 1.0 
                      ? 'Uploading ...(Please wait for the upload to complete)'
                      : 'Upload complete',
                    style: AppTextStyles.regular12.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}