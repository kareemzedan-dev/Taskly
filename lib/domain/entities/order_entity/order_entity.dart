import '../../../features/client/data/models/home/attaachments_dm.dart';

class OrderEntity {
  final String id;
  final String clientId;
  final String? freelancerId;
  final String title;
  final String? description;
  final String?category ;
  final List<AttachmentModel> attachments;
  final ServiceType serviceType;
  final double? budget;
  final OrderStatus status;
  final DateTime? deadline;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderEntity({
    required this.id,
    required this.clientId,
    this.freelancerId,
    required this.title,
    this.description,
    required this.category ,
    this.attachments = const [],
    this.serviceType = ServiceType.public,
    this.budget,
    this.status = OrderStatus.pending,
    this.deadline,
    required this.createdAt,
    required this.updatedAt,
  });
}

enum ServiceType { public, private }

enum OrderStatus { pending, accepted, inProgress, completed, cancelled }

