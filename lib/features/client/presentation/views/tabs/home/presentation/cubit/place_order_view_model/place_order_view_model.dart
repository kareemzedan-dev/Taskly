import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/core/cache/shared_preferences.dart';
import 'package:taskly/core/services/supabase_service.dart';
import 'package:taskly/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/client/domain/use_cases/home/home_use_case.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/cubit/place_order_view_model/place_order_view_model_states.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../../data/models/home/attaachments_dm.dart';

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
  List<AttachmentModel> uploadedAttachments = [];
  TextEditingController timeController = TextEditingController();
  final orderId = Uuid().v4();
  Map<String, double> uploadProgress = {};
  String selectedTimeUnit = "Days";
  final List<String> timeUnits = ["Hours", "Days", "Weeks"];
  String? selectedCategory;
  TextEditingController descriptionController = TextEditingController();
  final clientId = SharedPrefHelper.getString("id");



 

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
