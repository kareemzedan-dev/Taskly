import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/helper/failures.dart';
import 'package:taskly/core/helper/shared_preferences.dart';
import 'package:taskly/core/services/supabase_service.dart';
import 'package:taskly/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/client/domain/use_cases/home/home_use_case.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/cubit/place_order_view_model/place_order_view_model_states.dart';
import 'package:uuid/uuid.dart';

@injectable
class PlaceOrderViewModel extends Cubit<PlaceOrderViewModelStates> {
  HomeUseCase homeUseCase;
  PlaceOrderViewModel(this.homeUseCase) : super(PlaceOrderViewModelStatesInitial());
  final List<String> categories = [
    "Academic Sources",
    "Scientific Reports",
    "Mind Maps",
    "Translation",
    "Summarization",
    "Scientific Projects",
    "Presentations",
    "SPSS Analysis",
    "Proofreading",
    "Programming",
    "Tutorials",
    "Other",
  ];
  TextEditingController titleController = TextEditingController();
  List<File> localAttachments = [];
  List<Attachment> uploadedAttachments = [];
  TextEditingController timeController = TextEditingController();
  final orderId = Uuid().v4();
  Map<String, double> uploadProgress = {};
  String selectedTimeUnit = "Days";
  final List<String> timeUnits = ["Hours", "Days", "Weeks"];
  String? selectedCategory;
  TextEditingController descriptionController = TextEditingController();
  final clientId = SharedPrefHelper.getString("id");
  SupabaseService _supabaseService = SupabaseService();

  Future<List<Attachment>> uploadAttachments(
    List<File> files, {
    Function(String filePath, double progress)? onProgress,
  }) async {
    emit(PlaceOrderViewModelStatesAttachmentsLoading());

    try {
      List<Attachment> uploaded = [];

      for (var file in List<File>.from(files)) {
        final filePath = file.path;

        if (uploadProgress[filePath] == 1.0) {
          continue;
        }

        uploadProgress[filePath] = 0.0;
        emit(PlaceOrderViewModelStatesAttachmentsProgress(Map.from(uploadProgress)));

        final url = await _supabaseService.uploadFile(
          file,
          onProgress: (sentBytes, totalBytes) {
            final progress = sentBytes / totalBytes;
            uploadProgress[filePath] = progress;
            emit(
              PlaceOrderViewModelStatesAttachmentsProgress(Map.from(uploadProgress)),
            );
            if (onProgress != null) onProgress(filePath, progress);
          },
        );

        uploadProgress[filePath] = 1.0;
        emit(PlaceOrderViewModelStatesAttachmentsProgress(Map.from(uploadProgress)));

        final fileName = file.path.split('/').last;
        final newAttachment = Attachment(type: fileName, url: url);

        if (!uploadedAttachments.any((att) => att.type == fileName)) {
          uploaded.add(newAttachment);
        }
      }

      uploadedAttachments.addAll(uploaded);
      emit(PlaceOrderViewModelStatesAttachmentsSuccess(uploadedAttachments));
      return uploadedAttachments;
    } catch (e) {
      emit(PlaceOrderViewModelStatesAttachmentsError(e.toString()));
      return [];
    }
  }

  bool areAllAttachmentsUploaded() {
    return uploadProgress.values.every((progress) => progress == 1.0);
  }

  void clearUploadProgress() {
    uploadProgress.clear();
    emit(PlaceOrderViewModelStatesAttachmentsProgress(Map.from(uploadProgress)));
  }

  Future<Either<Failures, OrderEntity>> placeOrder(
    OrderEntity orderEntity,
  ) async {
    try {
      emit(PlaceOrderViewModelStatesLoading());
      final result = await homeUseCase.callPlaceOrder(orderEntity);
      result.fold(
        (failure) => emit(PlaceOrderViewModelStatesError(failure.message)),
        (order) => emit(PlaceOrderViewModelStatesSuccess(order)),
      );
      return result;
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  DateTime? calculateDeadline(String text, String timeUnit) {
    if (text.isEmpty) return null;

    final value = int.tryParse(text);
    if (value == null) return null;

    switch (timeUnit) {
      case "Hours":
        return DateTime.now().add(Duration(hours: value));
      case "Days":
        return DateTime.now().add(Duration(days: value));
      case "Weeks":
        return DateTime.now().add(Duration(days: value * 7));
      default:
        return null;
    }
  }
}
