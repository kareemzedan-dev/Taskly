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
  final PlaceOrderUseCase orderUseCase;

  PlaceOrderViewModel(this.orderUseCase)
      : super(PlaceOrderViewModelStatesInitial());

  // Controllers and fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<File> localAttachments = [];
  List<AttachmentModel> uploadedAttachments = [];
  final orderId = const Uuid().v4();
  final clientId = SharedPrefHelper.getString("id");

  Map<String, double> uploadProgress = {};

  String selectedTimeUnit = "";
  List<String> timeUnits = [];

  String? selectedCategory;
  String? freelancerId;

  // Set freelancer
  void setFreelancer(String id) {
    freelancerId = id;
    emit(PlaceOrderViewModelFreelancerSelected(id));
  }

  // Place order
  Future<Either<Failures, OrderEntity>> placeOrder(OrderEntity orderEntity) async {
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

  // Calculate deadline based on selected time unit
  DateTime? calculateDeadline(String timeValue, String selectedUnit) {
    final parsedValue = int.tryParse(timeValue);
    if (parsedValue == null) return null;

    if (selectedUnit == 'Hours' || selectedUnit == 'ساعات') {
      return DateTime.now().add(Duration(hours: parsedValue));
    } else if (selectedUnit == 'Days' || selectedUnit == 'أيام') {
      return DateTime.now().add(Duration(days: parsedValue));
    } else if (selectedUnit == 'Weeks' || selectedUnit == 'أسابيع') {
      return DateTime.now().add(Duration(days: parsedValue * 7));
    }

    return null;
  }

}
