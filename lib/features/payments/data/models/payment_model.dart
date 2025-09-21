import 'package:taskly/features/attachments/data/models/attachments_dm/attachments_dm.dart';
import '../../domain/entities/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  PaymentModel({
    required String id,
    required String clientId,
    required String freelancerId,
    required String orderId,
    required List<AttachmentModel> attachments,
    required double amount,
    required String status,
    required DateTime createdAt,
  }) : super(
    id: id,
    clientId: clientId,
    freelancerId: freelancerId,
    orderId: orderId,
    attachments: attachments,
    amount: amount,
    status: status,
    createdAt: createdAt,
  );

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      clientId: json['client_id'],
      freelancerId: json['freelancer_id'],
      orderId: json['order_id'],
      attachments: (json['attachments'] as List<dynamic>)
          .map((e) => AttachmentModel.fromJson(e))
          .toList(),
      amount: (json['amount'] as num).toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'freelancerId': freelancerId,
      'orderId': orderId,
      'attachments': attachments.map((e) => e.toJson()).toList(),
      'amount': amount,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
