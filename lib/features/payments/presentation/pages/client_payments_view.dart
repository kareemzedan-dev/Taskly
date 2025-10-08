import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/domain/entities/order_entity/order_entity.dart';
import '../widgets/client_payments_view_body.dart';
import '../../../attachments/presentation/manager/upload_attachments_view_model/upload_attachments_view_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/features/payments/presentation/manager/create_payment_view_model/create_payment_view_model.dart';

class ClientPaymentsView extends StatelessWidget {
  const ClientPaymentsView({super.key, required this.order});
  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<UploadAttachmentsViewModel>()),
        BlocProvider(create: (_) => getIt<CreatePaymentViewModel>()),
      ],
      child: WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
          backgroundColor: Colors.white,

          body: ClientPaymentsViewBody(order: order), // AppBar اتحذف من الـ Body
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    final uploadVM = context.read<UploadAttachmentsViewModel>();

    if (uploadVM.uploadedAttachments.isNotEmpty) {
      final shouldLeave = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Warning'),
          content: const Text(
            'You have uploaded payment proof but haven\'t pressed Make Payment. Are you sure you want to leave?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Stay'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Leave'),
            ),
          ],
        ),
      );
      return shouldLeave ?? false;
    }
    return true;
  }
}
