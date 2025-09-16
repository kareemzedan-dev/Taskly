import 'package:taskly/domain/entities/order_entity/order_entity.dart';

import '../../../features/client/data/models/home/attaachments_dm.dart';

class OrderDm extends OrderEntity {
  OrderDm({
    required super.id,
    required super.clientId,
    super.freelancerId,
    required super.title,
    super.description,
    super.category,
    super.attachments,
    super.serviceType,
    super.budget,
    super.status,
    super.deadline,
    required super.createdAt,
    required super.updatedAt,
  });

  factory OrderDm.fromJson(Map<String, dynamic> json) {
    return OrderDm(
      id: json['id'] as String,
      clientId: json['client_id'] as String,
      freelancerId: json['freelancer_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      category: json['category'] as String?,
      attachments: json['attachments'] != null
          ? (json['attachments'] as List)
              .map((e) => AttachmentModel.fromJson(e))
              .toList()
          : [],
      serviceType: (json['service_type'] as String) == 'private'
          ? ServiceType.private
          : ServiceType.public,
      budget: (json['budget'] as num?)?.toDouble(),

      status: _orderStatusFromString(json['status'] as String?),
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'freelancer_id': freelancerId,
      'title': title,
      'description': description,
      'category': category,
      'attachments': attachments.map((e) => e.toJson()).toList(),
      'service_type': serviceType == ServiceType.private ? 'private' : 'public',
      'budget': budget,
      'status': _orderStatusToString(status),
      'deadline': deadline?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  static OrderStatus _orderStatusFromString(String? status) {
    switch (status) {
      case 'Accepted':
        return OrderStatus.accepted;
        case 'Paid':
          return OrderStatus.paid;
      case 'In progress':
        return OrderStatus.inProgress;

      case 'Completed':
        return OrderStatus.completed;
      case 'Cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }

  static String _orderStatusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.accepted:
        return 'Accepted';
        case OrderStatus.paid:
          return 'Paid';
      case OrderStatus.inProgress:
        return 'In progress';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
      default:
        return 'Pending';
    }
  }

    static OrderDm fromEntity(OrderEntity entity) {
    return OrderDm(
      id: entity.id,
      clientId: entity.clientId,
      freelancerId: entity.freelancerId,
      title: entity.title,
      category: entity.category,
      description: entity.description,
      attachments: entity.attachments,
      serviceType: entity.serviceType,
      budget: entity.budget,
      status: entity.status,
      deadline: entity.deadline,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
    OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      clientId: clientId,
      freelancerId: freelancerId,
      title: title,
      description: description,
      category: category,
      attachments: attachments,
      serviceType: serviceType,
      budget: budget,
      status: status,
      deadline: deadline,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
 