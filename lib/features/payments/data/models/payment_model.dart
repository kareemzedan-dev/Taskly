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
    required DateTime updatedAt,
  }) : super(
    id: id,
    clientId: clientId,
    freelancerId: freelancerId,
    orderId: orderId,
    attachments: attachments,
    amount: amount,
    status: status,
    createdAt: createdAt,
    updatedAt: updatedAt,
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
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'freelancer_id': freelancerId,
      'order_id': orderId,
      'attachments': attachments.map((e) => e.toJson()).toList(),
      'amount': amount,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

}
