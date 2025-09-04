import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/helper/failures.dart';
import 'package:taskly/core/helper/shared_preferences.dart';
import 'package:taskly/core/services/supabase_service.dart';
import 'package:taskly/features/client/domain/entities/home/order_entity.dart';
import 'package:taskly/features/client/domain/use_cases/home/home_use_case.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/cubit/order_view_model/order_view_model_states.dart';
import 'package:uuid/uuid.dart';

@injectable
class OrderViewModel extends Cubit<OrderViewModelStates> {
  HomeUseCase homeUseCase;
  OrderViewModel(this.homeUseCase) : super(OrderViewModelStatesInitial());
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
  TextEditingController titleController = TextEditingController(text: "trans");
List<File> localAttachments = [];  
List<Attachment> uploadedAttachments = [];  
  TextEditingController timeController = TextEditingController();
  final orderId = Uuid().v4();

  String selectedTimeUnit = "Days";
  final List<String> timeUnits = ["Hours", "Days", "Weeks"];
  String? selectedCategory;
  TextEditingController descriptionController = TextEditingController();
  final clientId = SharedPrefHelper.getString("id");
  SupabaseService _supabaseService = SupabaseService();
  Future<List<Attachment>> uploadAttachments(List<File> files) async {
    emit(OrderViewModelStatesAttachmentsLoading());

    try {
      final uploaded = await Future.wait(
        files.map((file) async {
          final url = await _supabaseService.uploadFile(file);
          return Attachment(type: file.path.split('/').last, url: url);
        }),
      );

      uploadedAttachments = uploaded;
      emit(OrderViewModelStatesAttachmentsSuccess(uploaded));
      return uploaded;
    } catch (e) {
      emit(OrderViewModelStatesAttachmentsError(e.toString()));
      return [];
    }
  }

  Future<Either<Failures, OrderEntity>> placeOrder(
    OrderEntity orderEntity,
  ) async {
    try {
      emit(OrderViewModelStatesLoading());
      final result = await homeUseCase.callPlaceOrder(orderEntity);
      result.fold(
        (failure) => emit(OrderViewModelStatesError(failure.message)),
        (order) => emit(OrderViewModelStatesSuccess(order)),
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
