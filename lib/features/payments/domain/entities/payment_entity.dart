import 'package:taskly/features/attachments/data/models/attachments_dm/attachments_dm.dart';

class PaymentEntity {
  final String id;
  final String clientId;
  final String freelancerId;
  final String orderId;
  final List<AttachmentModel> attachments;
  final double amount;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  PaymentEntity({
    required this.id,
    required this.clientId,
    required this.freelancerId,
    required this.orderId,
    required this.attachments,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}
