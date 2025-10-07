import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/core/cache/shared_preferences.dart';
import 'package:taskly/features/client/domain/use_cases/home/place_order_use_case/place_order_use_case.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/view_model/place_order_view_model/place_order_view_model_states.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../../../attachments/data/models/attachments_dm/attachments_dm.dart';

@injectable
class PlaceOrderViewModel extends Cubit<PlaceOrderViewModelStates> {
  PlaceOrderUseCase orderUseCase;
  PlaceOrderViewModel(this.orderUseCase ) : super(PlaceOrderViewModelStatesInitial());
  final Map<String, String> categories = {
    "academic_sources": "Academic Sources",
    "scientific_reports": "Scientific Reports",
    "mind_maps": "Mind Maps",
    "translation": "Translation",
    "summaries": "Summaries",
    "scientific_projects": "Scientific Projects",
    "presentations": "Presentations",
    "statistical_analysis": "Statistical Analysis",
    "proofreading": "Proofreading",
    "resume": "Resume",
    "programming": "Programming",
    "tutorials": "Tutorials",
    "consultations": "Consultations",
    "graphic_design": "Graphic Design",
    "engineering_services": "Engineering Services",
    "financial_services": "Financial Services",
    "other": "Other",
  };

  TextEditingController titleController = TextEditingController();
  List<File> localAttachments = [];
  List<AttachmentModel> uploadedAttachments = [];
  TextEditingController timeController = TextEditingController();
  final orderId = const Uuid().v4();
  Map<String, double> uploadProgress = {};
  String selectedTimeUnit = "Days";
  final List<String> timeUnits = ["Hours", "Days", "Weeks"];
  String? selectedCategory;
  TextEditingController descriptionController = TextEditingController();
  final clientId = SharedPrefHelper.getString("id");
    String? freelancerId;


  void setFreelancer(String id) {
    freelancerId = id;
    emit(PlaceOrderViewModelFreelancerSelected(id));
  }

 

  Future<Either<Failures, OrderEntity>> placeOrder(
    OrderEntity orderEntity,
  ) async {
    try {
      emit(PlaceOrderViewModelStatesLoading());
      final result = await orderUseCase.callPlaceOrder(orderEntity);
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
